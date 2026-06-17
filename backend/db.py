import psycopg2

def get_conn():
    return psycopg2.connect(
        host="db",
        database="statrush",
        user="postgres",
        password="postgres",
        port=5432
    )
 #MnSxqTByplMYpuZnUnXmvkKIFNuafwcELcEbRnjepneQ7JmY4fHZhlXi5RkD