Precisa criar uma variável no airflow:

```
{
    "mercado_bitcoin_dag": {
        "bucket": "s3-belisco-dev-data-lake-raw", 
        "coins": ["BCH", "BTC", "ETH", "LTC"]
    }
}
```

E alterar a conexão `aws_default` com as suas credenciais