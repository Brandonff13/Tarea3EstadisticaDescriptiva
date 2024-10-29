# Dockerfile
FROM debian:bullseye-slim

# Agregar repositorios y actualizar
RUN apt-get update && \
    apt-get install -y openjdk-11-jre python3 python3-pip wget unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar Apache Spark
ENV SPARK_VERSION=3.5.3
ENV HADOOP_VERSION=3
RUN wget https://downloads.apache.org/spark/spark-3.5.3/spark-3.5.3-bin-hadoop3.tgz && \
    tar xvf spark-3.5.3-bin-hadoop3.tgz && \
    mv spark-3.5.3-bin-hadoop3 /opt/spark && \
    rm spark-3.5.3-bin-hadoop3.tgz

# Establecer las variables de entorno para Spark
ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH

# Copiar requirements.txt
COPY requirements.txt /app/requirements.txt

# Instalar dependencias
RUN pip3 install --no-cache-dir -r /app/requirements.txt

# Copiar el archivo de Excel
COPY cap_2015-2020.xlsx /app/cap_2015-2020.xlsx

COPY 2015.csv /app/2015.csv

COPY 2016.csv /app/2016.csv

COPY 2016pr.csv /app/2016pr.csv

COPY 2017.csv /app/2017.csv

COPY 2018.csv /app/2018.csv

COPY 2019.csv /app/2019.csv

COPY 2020.csv /app/2020.csv

# Copiar cualquier otro archivo necesario
COPY . /app

# Establecer el directorio de trabajo
WORKDIR /app

# Comando para iniciar Jupyter
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser"]

