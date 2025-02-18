import os
import psycopg
from psycopg.rows import dict_row
from dotenv import load_dotenv

load_dotenv()

# Database connection parameters
DBHOST = os.getenv("DBHOST")
DBNAME = os.getenv("DBNAME")
DBUSER = os.getenv("DBUSER")
DBPASS = os.getenv("DBPASS")

CONNINFO = f"dbname={DBNAME} user={DBUSER} password={DBPASS} host={DBHOST}"


def create_tables(conn):
    with conn.cursor() as cur:
        cur.execute(
            """
            CREATE TABLE IF NOT EXISTS users (
                id SERIAL PRIMARY KEY,
                username VARCHAR(50) UNIQUE NOT NULL,
                email VARCHAR(100) UNIQUE NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """
        )

        cur.execute(
            """
            CREATE TABLE IF NOT EXISTS products (
                id SERIAL PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                description TEXT,
                price DECIMAL(10,2) NOT NULL,
                stock INTEGER NOT NULL DEFAULT 0
            )
        """
        )

        cur.execute(
            """
            CREATE TABLE IF NOT EXISTS orders (
                id SERIAL PRIMARY KEY,
                user_id INTEGER REFERENCES users(id),
                total_amount DECIMAL(10,2) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """
        )


def insert_sample_data(conn):
    # Insert sample users
    with conn.cursor() as cur:
        users = [
            ("john_doe", "john@example.com"),
            ("jane_smith", "jane@example.com"),
            ("bob_wilson", "bob@example.com"),
        ]
        cur.executemany(
            "INSERT INTO users (username, email) VALUES (%s, %s) ON CONFLICT DO NOTHING",
            users,
        )

        # Insert sample products
        products = [
            ("Laptop", "High-performance laptop", 999.99, 10),
            ("Smartphone", "5G enabled smartphone", 699.99, 15),
            ("Headphones", "Wireless noise-canceling headphones", 199.99, 20),
            ("Tablet", "10-inch tablet with stylus", 449.99, 8),
        ]
        cur.executemany(
            "INSERT INTO products (name, description, price, stock) VALUES (%s, %s, %s, %s) ON CONFLICT DO NOTHING",
            products,
        )

        # Insert sample orders
        orders = [(1, 999.99), (2, 899.98), (1, 199.99), (3, 12.99)]
        cur.executemany(
            "INSERT INTO orders (user_id, total_amount) VALUES (%s, %s)", orders
        )


def verify_data(conn):
    # Using dict_row to get results as dictionaries
    with conn.cursor(row_factory=dict_row) as cur:
        # Get counts
        counts = {}
        for table in ["users", "products", "orders"]:
            cur.execute(f"SELECT COUNT(*) as count FROM {table}")
            result = cur.fetchone()
            counts[table] = result["count"]

        # Get sample data
        cur.execute(
            """
            SELECT u.username, COUNT(o.id) as order_count, SUM(o.total_amount) as total_spent
            FROM users u
            LEFT JOIN orders o ON u.id = o.user_id
            GROUP BY u.username
            ORDER BY total_spent DESC NULLS LAST
        """
        )
        user_stats = cur.fetchall()

        return counts, user_stats


def main():
    try:
        print("Connecting to the database...")
        # Using connection pool for better resource management
        with psycopg.Connection.connect(CONNINFO) as conn:
            # Create tables
            print("Creating tables...")
            create_tables(conn)

            # Insert data
            print("Inserting sample data...")
            insert_sample_data(conn)

            # Verify data
            print("\nVerifying data...")
            counts, user_stats = verify_data(conn)

            # Print summary
            print("\nData Summary:")
            print(f"Users: {counts['users']}")
            print(f"Products: {counts['products']}")
            print(f"Orders: {counts['orders']}")

            print("\nUser Statistics:")
            for user in user_stats:
                print(f"Username: {user['username']}")
                print(f"  Orders: {user['order_count']}")
                print(f"  Total Spent: ${user['total_spent']:.2f}")
                print()

    except psycopg.Error as e:
        print(f"An error occurred: {e}")


if __name__ == "__main__":
    print(DBHOST)
    print(DBNAME)
    print(DBUSER)
    main()
