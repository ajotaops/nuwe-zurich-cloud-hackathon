import json
import boto3
import os

def lambda_handler(event, context):
    try:
        # Get file name
        file_name = event['Records'][0]['s3']['object']['key']

        # Get bucket name
        bucket_name = event['Records'][0]['s3']['bucket']['name']

        # Read the JSON file
        s3_client = boto3.client('s3')
        response = s3_client.get_object(Bucket=bucket_name, Key=file_name)
        json_data = response['Body'].read().decode('utf-8')

        # Parse the JSON
        data = json.loads(json_data)

        # Create an instance of DynamoDB client
        dynamodb = boto3.resource('dynamodb')

        # Table name
        table_name = os.environ['tableSalesClients']

        # Create an instance of the table
        table = dynamodb.Table(table_name)

        # Insert the new items into the table
        with table.batch_writer() as batch:
            for item in data:
                batch.put_item(Item=item)

        # Log success message
        print(f'New file {file_name} detected, new clients added to table successfully.')

    except Exception as e:
        # Log the error
        print(f'Error processing file: {file_name}. {str(e)}')

        # Raise an exception to trigger an error response in Lambda
        raise e
