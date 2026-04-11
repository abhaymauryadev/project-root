from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route("/")
def health():
    return "healthy", 200

@app.route("/api/submittodoitem", methods=["GET"])
def submit_todo_info():
    return jsonify(
        {
            "message": "Send a POST request with JSON: { itemName, itemDescription }"
        }
    )

@app.route("/api/submittodoitem", methods=["POST"])
def submit_todo():
    data = request.get_json(silent=True) or {}
    itemName = data.get("itemName")
    itemDescription = data.get("itemDescription")

    print("Received:", itemName, itemDescription)

    return jsonify({"message": "Item Stored Successfully"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000 , debug=True)