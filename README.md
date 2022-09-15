docker run -it -w /app -v $(pwd):/app python:3.10.2-rc bash   

python -m venv venv 

source venv/bin/activate

python -m pip install -r app/requirements.txt  && pip freeze > requirements.txt && uvicorn app:app --reload --host 0.0.0.0

docker run -it python:3.10.2-rc /bin/sh