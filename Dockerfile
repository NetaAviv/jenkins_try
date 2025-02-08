# Step 1: Use an official Python runtime as a base image
FROM python:3.8-slim

# Step 2: Set the working directory in the container
WORKDIR /app

# Step 3: Copy the current directory contents (including the app.py) into the container
COPY . /app

# Step 4: Install dependencies listed in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Expose port 5000 for the Flask app
EXPOSE 5000

# Step 6: Set the environment variable for Flask
ENV FLASK_APP=app.py

# Step 7: Start the Flask app when the container runs
CMD ["flask", "run", "--host=0.0.0.0"]
