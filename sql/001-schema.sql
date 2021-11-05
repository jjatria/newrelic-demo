CREATE DATABASE panop CHARACTER SET utf8 COLLATE utf8_general_ci;

-- create users
CREATE USER     'site'@'%' IDENTIFIED BY '84aaa213dbb7aa3d67d57ba49acc2a71b7c4cd8bf689bfdf4372e4a34dceeca0';
CREATE USER 'readonly'@'%' IDENTIFIED BY '6a9914ea4e7fd8813a9c6a867eea0c3619ecb9441fbee9534852e06e816301e8';

-- add permissions
GRANT SELECT, UPDATE, DELETE, INSERT ON panop.* TO     'site'@'%';
GRANT SELECT                         ON panop.* TO 'readonly'@'%';
