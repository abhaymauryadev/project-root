from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/submittodoitem", methods=["POST"])
def submit_todo():
    data = request.json
    itemName = data.get("itemName")
    itemDescription = data.get("itemDescription")

    print("Received:", itemName, itemDescription)

    return jsonify({"message": "Item Stored Successfully"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000 , debug=True)