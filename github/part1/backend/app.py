from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
import os
from datetime import datetime

# Configuration
MONGO_URI = os.environ.get('MONGO_URI', 'mongodb://localhost:27017/')
DB_NAME = os.environ.get('MONGO_DB', 'todo_db')
COLLECTION_NAME = os.environ.get('MONGO_COLLECTION', 'items')

# MongoDB client
client = MongoClient(MONGO_URI)
db = client[DB_NAME]
collection = db[COLLECTION_NAME]

app = Flask(__name__)
CORS(app)

@app.route('/submittodoitem', methods=['POST'])
def submit_todoitem():
    """Accepts itemName and itemDescription via POST and stores in MongoDB.

    Accepts JSON or form-encoded data. Returns inserted document id on success.
    """
    data = None
    # Try JSON first, then form
    if request.is_json:
        data = request.get_json()
    else:
        data = request.form.to_dict()

    item_name = (data.get('itemName') or data.get('item_name') or data.get('name')) if data else None
    item_desc = (data.get('itemDescription') or data.get('item_description') or data.get('description')) if data else ''

    if not item_name or not item_name.strip():
        return jsonify({'error': 'itemName is required'}), 400

    doc = {
        'name': item_name.strip(),
        'description': (item_desc or '').strip(),
        'created_at': datetime.utcnow()
    }

    result = collection.insert_one(doc)

    return jsonify({'success': True, 'id': str(result.inserted_id)}), 201


@app.route('/todos', methods=['GET'])
def list_todos():
    """Optional helper: list all todo items (most recent first)."""
    items = list(collection.find().sort('created_at', -1))
    out = []
    for it in items:
        out.append({
            'id': str(it.get('_id')),
            'name': it.get('name'),
            'description': it.get('description'),
            'created_at': it.get('created_at').isoformat() if it.get('created_at') else None
        })
    return jsonify(out)


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
