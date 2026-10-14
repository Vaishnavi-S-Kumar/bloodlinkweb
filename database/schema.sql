
-- BloodLink-Web database schema
-- This script is for the new web application.
-- Do not run it against the old Swing project's database.

CREATE DATABASE IF NOT EXISTS bloodlink_web;
USE bloodlink_web;

-- 1. Common account information
CREATE TABLE IF NOT EXISTS users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('DONOR', 'HOSPITAL') NOT NULL,
    status ENUM('PENDING', 'APPROVED', 'REJECTED')
        NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Donor profile
CREATE TABLE IF NOT EXISTS donors (
    donor_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(30) NOT NULL,
    blood_group VARCHAR(3) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    location VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 3. Hospital profile
CREATE TABLE IF NOT EXISTS hospitals (
    hospital_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL UNIQUE,
    hospital_name VARCHAR(150) NOT NULL,
    registration_number VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(255) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    hospital_email VARCHAR(255) NOT NULL,
    hospital_type VARCHAR(30) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 4. Blood requests
CREATE TABLE IF NOT EXISTS blood_requests (
    request_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    hospital_id BIGINT NOT NULL,
    blood_group VARCHAR(3) NOT NULL,
    units_needed INT NOT NULL,
    location VARCHAR(255) NOT NULL,
    urgency VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'OPEN',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id)
);

-- 5. Donor responses to blood requests
CREATE TABLE IF NOT EXISTS donor_responses (
    response_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    request_id BIGINT NOT NULL,
    donor_id BIGINT NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    responded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (request_id, donor_id),
    FOREIGN KEY (request_id) REFERENCES blood_requests(request_id),
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id)
);

-- 6. Donation history
CREATE TABLE IF NOT EXISTS donation_history (
    donation_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    donor_id BIGINT NOT NULL,
    hospital_id BIGINT,
    donation_date DATE NOT NULL,
    units_donated INT NOT NULL DEFAULT 1,
    notes VARCHAR(500),
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id),
    FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id)
);

-- 7. Notifications
CREATE TABLE IF NOT EXISTS notifications (
    notification_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    message VARCHAR(500) NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
