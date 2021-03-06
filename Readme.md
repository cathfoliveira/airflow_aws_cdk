# Airflow 2.0 Fargate CDK

Deploy of Airflow 2.0 using ECS Fargate and AWS CDK.

## Makefile

A comprehensive Makefile is available to execute common tasks. Run the following for help:

```
make help
```

###  Local Development
To bring Airflow up do `dev-deploy-local` and `make airflow-local-up`

It will be available on `http://127.0.0.1:8080`

Credentials are set with environment variables in `docker-compose.yml`
```
AIRFLOW_USERNAME: Airflow application username. Default: user
AIRFLOW_PASSWORD: Airflow application password. Default: Cath123
AIRFLOW_EMAIL: Airflow application email. Default: user@example.com
```

To shut it down do `make airflow-local-down` and `make dev-clean-local`

## AWS CDK Development
If you wish to make changes to the infrastructure, you might need to have AWS CDK installed.  
Please follow the [AWS guide](https://docs.aws.amazon.com/cdk/latest/guide/getting_started.html) to install it.

## References
- Uses Airflow image from [Bitnami](https://github.com/bitnami/bitnami-docker-airflow).
- [How Bootcamp & André Sionek](https://learn.howedu.com.br/curso/engenharia-de-dados)
