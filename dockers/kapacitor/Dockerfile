FROM kapacitor:1.5

RUN apt install -y jq && rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/yunion/bin:${PATH}"

RUN mkdir -p /opt/yunion/bin

ADD ./shell/* /opt/yunion/bin/

ADD ./climc /opt/yunion/bin/

ADD ./load-directory-service /opt/yunion/load-directory-service
