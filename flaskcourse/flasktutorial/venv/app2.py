from flask import Flask, render_template, request, jsonify
from pymongo import MongoClient

app = Flask(__name__)

# MongoDB Atlas (replace with your string)
client = MongoClient(
    "YOUR_MONGODB_ATLAS_CONNECTION_STRING"
)
db = client["testdb"]
collection = db["users"]

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/submit", methods=["POST"])
def submit():
    try:
        data = request.get_json()
        print("Received:", data)   # DEBUG

        name = data.get("name")
        email = data.get("email")

        if not name or not email:
            return jsonify({"error": "All fields are required"}), 400

        collection.insert_one({
            "name": name,
            "email": email
        })

        return jsonify({"success": True})

    except Exception as e:
        print("ERROR:", e)
        return jsonify({"error": str(e)}), 500

@app.route("/success")
def success():
    return render_template("success.html")

if __name__ == "__main__":
    app.run(debug=True)
