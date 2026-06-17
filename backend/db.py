import psycopg2

def get_conn():
    return psycopg2.connect(
        host="localhost",
        database="statrush",
        user="postgres",
        password="postgres"
    )
 #MnSxqTByplMYpuZnUnXmvkKIFNuafwcELcEbRnjepneQ7JmY4fHZhlXi5RkD