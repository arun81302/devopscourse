from flask import Flask, request, jsonify
from flask_cors import CORS
import json
from datetime import datetime

app = Flask(__name__)
CORS(app) 


submissions = []

@app.route('/')
def home():
    return jsonify({
        'message': 'Flask Backend API',
        'status': 'running',
        'endpoints': ['/api/submit', '/api/submissions']
    })

@app.route('/api/submit', methods=['POST'])
def submit_form():
    try:

        data = request.get_json()
        
    
        required_fields = ['name', 'email', 'phone', 'dob', 'gender', 'course']
        for field in required_fields:
            if field not in data or not data[field]:
                return jsonify({
                    'success': False,
                    'message': f'Missing required field: {field}'
                }), 400
        

        data['timestamp'] = datetime.now().isoformat()
        data['id'] = len(submissions) + 1
        

        submissions.append(data)
        
        print(f"New submission received: {data['name']} - {data['email']}")
        
        return jsonify({
            'success': True,
            'message': 'Form submitted successfully',
            'data': data
        }), 200
        
    except Exception as e:
        print(f"Error processing submission: {str(e)}")
        return jsonify({
            'success': False,
            'message': f'Error processing form: {str(e)}'
        }), 500

@app.route('/api/submissions', methods=['GET'])
def get_submissions():
    return jsonify({
        'success': True,
        'count': len(submissions),
        'submissions': submissions
    })

@app.route('/api/submissions/<int:submission_id>', methods=['GET'])
def get_submission(submission_id):
    submission = next((s for s in submissions if s['id'] == submission_id), None)
    if submission:
        return jsonify({
            'success': True,
            'submission': submission
        })
    return jsonify({
        'success': False,
        'message': 'Submission not found'
    }), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
