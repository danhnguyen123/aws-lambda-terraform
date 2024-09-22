import boto3
import requests
from datetime import datetime
import awswrangler as wr
from helpers.config import config
from helpers.custom_logging import LoggingHelper

logger = LoggingHelper.get_configured_logger(config.SERVICE_NAME)
sns_client = boto3.client('sns')

def main(event, context):
    # TODO implement
    try:
        logger.debug("Start execution")
        event_record = event.get("Records")[0]
        bucket = event_record.get("s3").get("bucket").get("name")
        key = event_record.get("s3").get("object").get("key")
        s3_file_path = f"s3://{bucket}/{key}"
        logger.debug("Read & transform data from S3")
        df = wr.s3.read_csv([s3_file_path])
        df["InvoiceDateTime"] = df["InvoiceDate"].map(lambda x: datetime.strptime(x, "%Y-%m-%d %H:%M:%S"))
        df["InvoiceDate"] = df["InvoiceDate"].map(lambda x: x.split(" ")[0])
        rename_columns= {
            "Invoice": "invoice_id",
            "StockCode": "stock_code",
            "Description": "description",
            "Quantity": "quantity",
            "InvoiceDate": "invoice_date",
            "Price": "price",
            "Customer ID": "customer_id",
            "Country": "country",
            "InvoiceDateTime": "invoice_datetime"
            }
        df = df.rename(columns=rename_columns)

        # Ingest to staging table
        database = "lakehouse_iceberg_stg"
        table="retail_invoice"

        logger.debug("Create database if it doesn'n exist")
        wr.catalog.create_database(name=database, description="Lakehouse Iceberg staging for dev/test",exist_ok=True)
        wr.athena.to_iceberg(
            df=df,
            database=database,
            table=table,
            table_location=f"s3://{bucket}/{database}/{table}/",
            # partition_cols=["InvoiceDate"],
            mode="append",
            additional_table_properties={
                'optimize_rewrite_data_file_threshold': '10',
                'optimize_rewrite_delete_file_threshold': '10'
                },
            schema_evolution=True,
            keep_files=False,
            temp_path=f"s3://{bucket}/{database}/temp/"
        )
        logger.debug("End execution")
    except Exception as e:
        logger.error(e)
        message = f"Input S3 File {s3_file_path} processing is Failed !!"
        respone = sns_client.publish(Subject="FAILED - Daily Data Processing", TargetArn=config.SNS_ARN, Message=message, MessageStructure='text')
