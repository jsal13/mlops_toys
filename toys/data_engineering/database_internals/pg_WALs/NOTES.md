# WAL Notes

## What are WALs?

Write-Ahead Logs ensure data integrity and durability: they record changes to the database _before_ they are applied, so that PG can recover data and restore the DB to its most recent state in case it crashes or fails.

## How does it work?

Suppose we have a PG DB with a table like this:

```sql
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    full_name TEXT,
    account_value NUMERIC
);
```

Let's insert a few things into this table for testing:

```sql
INSERT INTO customers (full_name, account_value) VALUES ('Abby', 10.00), ('Bitsy', 200.00), ('Cath', -1000.00);
```

Great.  Now, let's begin a transaction to modify some records:

```sql
BEGIN;
UPDATE customers SET account_value = account_value - 10.00 WHERE full_name = 'Abby';
UPDATE customers SET account_value = account_value + 200.00 WHERE full_name = 'Bitsy';
UPDATE customers SET account_value = 0 WHERE full_name = 'Cath';
```

Notice we have not `COMMIT` this transaction yet.  

When these statements above are executed, PG generates WAL records for each and stores them in an in-memory WAL buffer.  When the `COMMIT;` statement is run, PG will flush the WAL buffer and the changes are made.

## What if there's a crash mid-change?

When PG restarts, it recovers: it identifies the REDO point from the most recent checkpoint, which is the position in the WAL from which recovery should start.

*Q: if WAL is in-memory, doesn't this get killed if there's a crash?*

If Syncrononous Commit is enabled, this ensures WAL records are all flushed to disk before a transaction is considered complete.  

## How does PG read WALfiles?

tl;dr, it uses XLOG records from WAL files and compares LSNs (log sequence number) to ensure all committed transactions are applied.
