from flask import Flask, request, jsonify
import sys
sys.path.append(r"C:\Users\matth\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.11_qbz5n2kfra8p0\LocalCache\local-packages\Python311\site-packages")
import psycopg2
from psycopg2.extras import RealDictCursor
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)

# PostgreSQL database configuration
DB_CONFIG = {
    'dbname': 'moviemeter_db',  # Name of your database
    'user': 'postgres',         # Your PostgreSQL username
    'password': 'Flowers12',    # Your PostgreSQL password
    'host': 'localhost',        # Host (use 'localhost' for local development)
    'port': 5432                # Default PostgreSQL port
}

# Test route
@app.route('/')
def home():
    return jsonify({'message': 'Welcome to the MovieMeter API'})

@app.route('/register', methods=['POST'])
def register_user():
    try:
        print("Register endpoint hit!")  # Log when the endpoint is accessed
        data = request.get_json()
        print("Data received:", data)  # Log the received data

        # Extract data from request
        username = data.get('username')
        email = data.get('email')
        password = data.get('password')

        # Validate input
        if not username or not email or not password:
            return jsonify({'error': 'Missing required fields'}), 400

        # Hash the password for security
        password_hash = generate_password_hash(password)

        # Insert user into the database
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()
        query = 'INSERT INTO users (username, email, password_hash) VALUES (%s, %s, %s) RETURNING id'
        cursor.execute(query, (username, email, password_hash))
        user_id = cursor.fetchone()[0]
        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({'message': 'User registered successfully', 'user_id': user_id}), 201
    except Exception as e:
        print("Error occurred:", e)  # Log any errors
        return jsonify({'error': str(e)}), 500

#login
@app.route('/login', methods=['POST'])
def login_user():
    try:
        data = request.get_json()
        username = data['username']
        password = data['password']

        if not username or not password:
            return jsonify({'error': 'Missing required fields'}), 400

        # Query the database for the user
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        query = 'SELECT id, password_hash FROM users WHERE username = %s'
        cursor.execute(query, (username,))
        user = cursor.fetchone()
        cursor.close()
        conn.close()

        if user is None or not check_password_hash(user['password_hash'], password):
            return jsonify({'error': 'Invalid username or password'}), 401

        # Return the user ID on successful login
        return jsonify({'message': 'Login successful', 'user_id': user['id']}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500



# Route to get all comments for a specific movie
@app.route('/comments/<int:movie_id>', methods=['GET'])
def get_comments(movie_id):
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor(cursor_factory=RealDictCursor)

        # Query to fetch comments along with usernames
        query = '''
            SELECT d.content, d.timestamp, u.username
            FROM discussions d
            INNER JOIN users u ON d.user_id = u.id
            WHERE d.movie_id = %s
            ORDER BY d.timestamp
        '''
        cursor.execute(query, (movie_id,))
        comments = cursor.fetchall()
        
        cursor.close()
        conn.close()
        
        return jsonify(comments)  # Return comments with usernames
    except Exception as e:
        print(f"Error occurred: {e}")
        return jsonify({'error': str(e)}), 500


# Route to add a new comment
# Route to add a new comment
@app.route('/comments', methods=['POST'])
def add_comment():
    try:
        data = request.get_json()
        movie_id = data['movie_id']
        user_id = data['user_id']
        content = data['content']

        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor(cursor_factory=RealDictCursor)

        # Insert the comment into the discussions table
        insert_query = '''
            INSERT INTO discussions (movie_id, user_id, content) 
            VALUES (%s, %s, %s) 
            RETURNING id, movie_id, user_id, content, timestamp
        '''
        cursor.execute(insert_query, (movie_id, user_id, content))
        new_comment = cursor.fetchone()

        # Fetch the username of the user who posted the comment
        user_query = 'SELECT username FROM users WHERE id = %s'
        cursor.execute(user_query, (user_id,))
        user = cursor.fetchone()

        conn.commit()
        cursor.close()
        conn.close()

        # Include the username in the response
        new_comment['username'] = user['username'] if user else None

        return jsonify({'message': 'Comment added successfully', 'comment': new_comment}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=True)
