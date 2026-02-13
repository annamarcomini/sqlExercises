-- insere valores na tabela em cada campo desse
INSERT INTO users.user(name, email, password_hash) 
  VALUES (
  'João',
  'joao@email.com',
  '$2b$12$N9qo8uLOickgx2ZMRZo5e.u6a8rM6x5jvZ1pYp8q6B5X0X5p6K9W'
);
SELECT * FROM users.user;