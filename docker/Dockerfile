### Checkout stage ###
FROM busybox AS gtd
# Fetch the latest repository snapshot for the demo site
ADD https://github.com/shacker/gtd/archive/master.zip /src/gtd.zip
WORKDIR /src
RUN unzip -x gtd.zip


### Build stage ###
FROM python:3.6-slim
MAINTAINER yaroslav.zh@gmail.com

# Install pipenv and PostgreSQL drivers
RUN pip3 install pipenv psycopg2-binary

# Copy unpacked source code for the demo site
COPY --from=gtd /src/gtd-master /srv/gtd

# Install django-todo and dependencies
WORKDIR /srv/gtd
RUN pipenv install

# Set the default command to run the built-in Django web server
ENTRYPOINT ["pipenv", "run"]
CMD ["./manage.py", "runserver", "0.0.0.0:5000"]

# Add Django settings overrides (PostgreSQL connection, allowed hosts etc.)
ADD local.py /srv/gtd/project/local.py
