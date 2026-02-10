CREATE TABLE quiz_tag (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  slug VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_quiz_tag_slug (slug)
);

CREATE TABLE quiz_tagging (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  quiz_id BIGINT UNSIGNED NOT NULL,
  quiz_tag_id INT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_quiz_tagging (quiz_id, quiz_tag_id),
  CONSTRAINT fk_quiz_tagging_quiz FOREIGN KEY (quiz_id) REFERENCES quiz (id),
  CONSTRAINT fk_quiz_tagging_quiz_tag FOREIGN KEY (quiz_tag_id) REFERENCES quiz_tag (id)
);