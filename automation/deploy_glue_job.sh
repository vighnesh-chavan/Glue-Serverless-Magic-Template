#!/bin/bash
s3_bucket="$1"
role="$2"

job_names=$(aws glue get-jobs | jq -r '.Jobs | map(.Name)[]')

for file in jobs/*.py; do
    filename=$(basename "$file" .py)
    
    if [ "$filename" != "__init__" ]; then

        if [[ $job_names != *"$filename"* ]]; then

            jq --arg NAME "$filename" \
                --arg SCRIPT_LOCATION "s3://$s3_bucket/scripts/$filename.py" \
                --arg ROLE "$role" \
                --arg TEMP_DIR "s3://$s3_bucket/Logs/temp/" \
                --arg EVENT_LOG "s3://$s3_bucket/Logs/UILogs/" \
                --arg WHEEL "s3://$s3_bucket/scripts/app-0.5-py3-none-any.whl" \
                --arg S3_READ_PATH "s3://$s3_bucket/rawdata/" \
                --arg S3_WRITE_PATH "s3://$s3_bucket/transformed/" \
                '.Name=$NAME | 
                .Command.ScriptLocation=$SCRIPT_LOCATION | 
                .Role=$ROLE | 
                .DefaultArguments["--TempDir"]=$TEMP_DIR | 
                .DefaultArguments["--spark-event-logs-path"]=$EVENT_LOG | 
                .DefaultArguments["--extra-py-files"]=$WHEEL |
                .DefaultArguments["--S3_READ_PATH"]=$S3_READ_PATH |
                .DefaultArguments["--S3_WRITE_PATH"]=$S3_WRITE_PATH' \
                automation/create_glue_job.json > "automation/output_$filename.json"

            aws glue create-job --cli-input-json file://"automation/output_$filename.json"

        else

            jq --arg NAME "$filename" \
                --arg SCRIPT_LOCATION "s3://$s3_bucket/scripts/$filename.py" \
                --arg ROLE "$role" \
                --arg TEMP_DIR "s3://$s3_bucket/Logs/temp/" \
                --arg EVENT_LOG "s3://$s3_bucket/Logs/UILogs/" \
                --arg WHEEL "s3://$s3_bucket/scripts/app-0.9-py3-none-any.whl" \
                --arg S3_READ_PATH "s3://$s3_bucket/rawdata/" \
                --arg S3_WRITE_PATH "s3://$s3_bucket/transformed/" \
                '.JobName=$NAME | 
                .JobUpdate.Command.ScriptLocation=$SCRIPT_LOCATION | 
                .JobUpdate.Role=$ROLE | 
                .JobUpdate.DefaultArguments["--TempDir"]=$TEMP_DIR | 
                .JobUpdate.DefaultArguments["--spark-event-logs-path"]=$EVENT_LOG | 
                .JobUpdate.DefaultArguments["--extra-py-files"]=$WHEEL |
                .JobUpdate.DefaultArguments["--S3_READ_PATH"]=$S3_READ_PATH |
                .JobUpdate.DefaultArguments["--S3_WRITE_PATH"]=$S3_WRITE_PATH' \
                automation/update_glue_job.json > "automation/output_$filename.json"

            aws glue update-job --cli-input-json file://"automation/output_$filename.json"
        fi
    fi
done
