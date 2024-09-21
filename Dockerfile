FROM public.ecr.aws/lambda/python:3.11

# Copy requirements.txt
COPY src/ ${LAMBDA_TASK_ROOT}

# Install the specified packages
RUN pip install -r requirements.txt

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "main.handler" ]