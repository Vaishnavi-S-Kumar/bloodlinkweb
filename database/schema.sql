
CREATE DATABASE IF NOT EXISTS bloodlink_web;
USE bloodlink_web;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    email VARCHAR(100) UNIQUE
);

CREATE TABLE donors (
    donor_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(20),
    blood_group VARCHAR(5) NOT NULL,
    phone VARCHAR(15),
    location VARCHAR(100),
    availability VARCHAR(20) DEFAULT 'AVAILABLE',
    last_donation_date DATE,
    eligibility VARCHAR(20) DEFAULT 'PENDING',
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE hospitals (
    hospital_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    hospital_name VARCHAR(150) NOT NULL,
    registration_number VARCHAR(50),
    location VARCHAR(100),
    contact_number VARCHAR(15),
    email VARCHAR(100),
    type VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE blood_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    hospital_id INT NOT NULL,
    patient_name VARCHAR(100),
    blood_group VARCHAR(5) NOT NULL,
    units_required INT NOT NULL,
    location VARCHAR(100),
    priority VARCHAR(20) DEFAULT 'NORMAL',
    contact_number VARCHAR(15),
    request_status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id)
);

CREATE TABLE donor_responses (
    response_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    donor_id INT NOT NULL,
    response VARCHAR(20) NOT NULL,
    responded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (request_id, donor_id),
    FOREIGN KEY (request_id) REFERENCES blood_requests(request_id),
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id)
);

CREATE TABLE donation_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT NOT NULL,
    donation_date DATE NOT NULL,
    hospital_name VARCHAR(150),
    blood_group VARCHAR(5),
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id)
);

CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message VARCHAR(255) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
