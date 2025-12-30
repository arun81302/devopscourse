# Backend for To-Do Page (Flask + MongoDB)

This small Flask app exposes a POST route `/submittodoitem` to accept to-do items and store them in MongoDB.

Files:
- `app.py` — Flask application with `/submittodoitem` and an optional `GET /todos` route.
- `requirements.txt` — Python dependencies.

Setup

1. Create a Python virtual environment and install dependencies:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

2. Configure MongoDB connection via environment variable (optional):

```bash
export MONGO_URI='mongodb://localhost:27017/'
export MONGO_DB='todo_db'
export MONGO_COLLECTION='items'
```

3. Run the app:

```bash
python app.py
```

The app will listen on `http://0.0.0.0:5000` by default.

Test the POST route with `curl` (JSON):

```bash
curl -X POST http://localhost:5000/submittodoitem \
  -H "Content-Type: application/json" \
  -d '{"itemName":"Buy milk","itemDescription":"2 liters"}'
```

Or form-encoded (from an HTML form):

```bash
curl -X POST http://localhost:5000/submittodoitem \
  -d "itemName=Buy+milk" \
  -d "itemDescription=2+liters"
```

Fetch saved items:

```bash
curl http://localhost:5000/todos
```

Notes
- For MongoDB Atlas use a `mongodb+srv://` URI in `MONGO_URI` environment variable.
- `flask-cors` is enabled so the frontend can POST directly to this backend from a different origin.
