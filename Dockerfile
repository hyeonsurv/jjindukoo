# Use a lightweight Python image
FROM python:3.10-slim

# Set the working directory inside the container
WORKDIR /app

# Copy all files from the repository into the container
COPY . /app

# If the zip archive exists, extract it. This makes the Dockerfile work
# whether your repository contains the unzipped app files or a zip archive.
# If the archive mvp_board_app_deploy.zip exists, extract it
RUN if [ -f mvp_board_app_deploy.zip ]; then \
        python -c "import zipfile; zipfile.ZipFile('mvp_board_app_deploy.zip').extractall('.')"; \
    fi

# Install Python dependencies
# Using --no-cache-dir reduces image size by not caching pip downloads
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port Render expects the web service to listen on (10000 by default)
EXPOSE 10000

# Start the Flask application using Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:10000", "app:app"]