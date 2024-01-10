# Glue Serverless Magic Template ✨

This is a template for using Glue in it's serverless style. We can develop & test ETL jobs locally then push them to the AWS Glue.

Steps:

1. Clone this repo

2. Start the AWS Glue 4 docker container . You can refer to the ```automation/init_docker_image_example.sh``` file. Put your aws credentials & root project location in it.

3. Make a .env file in the root location. 

4. Write your python script in the jobs folder. Refer to the ```jobs/job_demo.py``` file for creating ETL scripts. You can add multiple scripts in the job, it's up to you!

5. To run the script in the docker container, use ```spark-submit```  command. For example:
    ```
    spark-submit jobs/main.py
    ```

6. Deploying the script & setting up Glue is also taken care using GitHub Workflows, just setup the following secrets in your repo:
    ```
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    S3_BUCKET_NAME
    S3_SCRIPTS_PATH
    AWS_REGION
    AWS_GLUE_ROLE
    ```

## Note

You need to make a .env file in the root folder with environment variables. Also make sure to pass this environment in the ```automation/deploy_glue_job.sh``` file so that they get deployed to the actual Glue job on production.

Thats it! You can do magic with serverless architecture 😃