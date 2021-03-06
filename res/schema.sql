CREATE TABLE IF NOT EXISTS organizer (
    id int(11) NOT NULL AUTO_INCREMENT,
    create_datetime int(11) DEFAULT 0 NOT NULL,
    username varchar(255) DEFAULT '' NOT NULL,
    email varchar(255) DEFAULT '' NOT NULL,
    password varchar(255) DEFAULT '' NOT NULL,
    public_name varchar(255) DEFAULT '' NOT NULL,
    public_organisation varchar(255) DEFAULT '' NOT NULL,
    confirmed_email tinyint(2) DEFAULT 0 NOT NULL,
    super_admin tinyint(2) DEFAULT 0 NOT NULL,
    verified tinyint(2) DEFAULT 0 NOT NULL,
    hash varchar(255) DEFAULT '' NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS event (
    id int(11) NOT NULL AUTO_INCREMENT,
    organizer_id int(11) DEFAULT 0 NOT NULL,
    create_datetime int(11) DEFAULT 0 NOT NULL,
    modified_datetime int(11) DEFAULT 0 NOT NULL,
    scheduled_datetime int(11) DEFAULT 0 NOT NULL,
    title varchar(255) DEFAULT '' NOT NULL,
    lobby_open tinyint(2) DEFAULT 0 NOT NULL,
    active tinyint(2) DEFAULT 0 NOT NULL,
    deleted tinyint(2) DEFAULT 0 NOT NULL,
    description text,
    image_path varchar(255) DEFAULT '' NOT NULL,
    slug varchar(150) DEFAULT '' NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY (slug),
    FOREIGN KEY (organizer_id) REFERENCES organizer (id)
);
CREATE TABLE IF NOT EXISTS poll (
    id int(11) NOT NULL AUTO_INCREMENT,
    event_id int(11) DEFAULT 0 NOT NULL,
    original_id int(11) DEFAULT NULL,
    create_datetime int(11) DEFAULT 0 NOT NULL,
    title varchar(255) DEFAULT '' NOT NULL,
    type int(11) DEFAULT 0 NOT NULL,
    repeated tinyint(2) DEFAULT 0 NOT NULL,
    min_votes int(11) DEFAULT 0 NOT NULL,
    max_votes int(11) DEFAULT 1 NOT NULL,
    allow_abstain tinyint(2) DEFAULT 0 NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (event_id) REFERENCES event (id),
    FOREIGN KEY (original_id) REFERENCES poll (id)
);
CREATE TABLE IF NOT EXISTS event_user (
    id int(11) NOT NULL AUTO_INCREMENT,
    event_id int(11) DEFAULT 0 NOT NULL,
    create_datetime int(11) DEFAULT 0 NOT NULL,
    username varchar(255) DEFAULT '' NOT NULL,
    email varchar(255) DEFAULT '' NOT NULL,
    password varchar(255) DEFAULT '' NOT NULL,
    public_name varchar(255) DEFAULT '' NOT NULL,
    allow_to_vote tinyint(2) DEFAULT 0 NOT NULL,
    vote_amount int(4) DEFAULT 0 NOT NULL,
    online tinyint(2) DEFAULT 0 NOT NULL,
    coorganizer tinyint(2) DEFAULT 0 NOT NULL,
    verified tinyint(2) DEFAULT 0 NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (event_id) REFERENCES event (id)
);
CREATE TABLE IF NOT EXISTS poll_user (
    id int(11) NOT NULL AUTO_INCREMENT,
    event_user_id int(11) DEFAULT 0 NOT NULL,
    public_name varchar(255) DEFAULT '' NOT NULL,
    poll_id int(11) DEFAULT 0 NOT NULL,
    create_datetime int(11) DEFAULT 0 NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (event_user_id) REFERENCES event_user (id),
    FOREIGN KEY (poll_id) REFERENCES poll (id)
);
CREATE TABLE IF NOT EXISTS poll_possible_answer (
    id int(11) NOT NULL AUTO_INCREMENT,
    poll_id int(11) DEFAULT 0 NOT NULL,
    create_datetime int(11) DEFAULT 0 NOT NULL,
    content varchar(255) DEFAULT '' NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (poll_id) REFERENCES poll (id)
);
CREATE TABLE IF NOT EXISTS poll_result (
    id int(11) NOT NULL AUTO_INCREMENT,
    poll_id int(11) DEFAULT 0 NOT NULL,
    max_votes int(11) DEFAULT 0 NOT NULL,
    max_vote_cycles int(11) DEFAULT 0 NOT NULL,
    create_datetime int(11) DEFAULT 0 NOT NULL,
    type tinyint(2) DEFAULT 0 NOT NULL,
    closed tinyint(2) DEFAULT 0 NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (poll_id) REFERENCES poll (id)
);
CREATE TABLE IF NOT EXISTS poll_answer (
    id int(11) NOT NULL AUTO_INCREMENT,
    poll_result_id int(11) DEFAULT 0 NOT NULL,
    poll_possible_answer_id int(11) NULL,
    answer_content varchar(255) DEFAULT '' NOT NULL,
    poll_user_id int(11) NULL,
    create_datetime int(11) DEFAULT 0 NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (poll_result_id) REFERENCES poll_result (id),
    FOREIGN KEY (poll_possible_answer_id) REFERENCES poll_possible_answer (id),
    FOREIGN KEY (poll_user_id) REFERENCES poll_user (id)
);
CREATE TABLE IF NOT EXISTS poll_user_voted (
    id int(11) NOT NULL AUTO_INCREMENT,
    poll_result_id int(11) DEFAULT 0 NOT NULL,
    event_user_id int(11) DEFAULT 0 NOT NULL,
    vote_cycle INT(11) DEFAULT 0 NOT NULL,
    create_datetime int(11) DEFAULT 0 NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (poll_result_id) REFERENCES poll_result (id),
    FOREIGN KEY (event_user_id) REFERENCES event_user (id)
);
CREATE TABLE IF NOT EXISTS jwt_refresh_token (
    id int(11) NOT NULL AUTO_INCREMENT,
    token varchar(255) DEFAULT '' NOT NULL,
    organizer_id int(11) DEFAULT NULL,
    event_user_id int(11) DEFAULT NULL,
    create_datetime int(11) DEFAULT 0,
    PRIMARY KEY (id),
    FOREIGN KEY (organizer_id) REFERENCES organizer (id),
    FOREIGN KEY (event_user_id) REFERENCES event_user (id)
);
