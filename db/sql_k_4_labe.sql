
-- ==========================
-- Схема базы данных для системы оценки английского языка + product/provider
-- PostgreSQL
-- ==========================

-- Таблица пользователей
CREATE TABLE users (
    user_id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Темы тестов
CREATE TABLE topics (
    topic_id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    difficulty_level VARCHAR(50) NOT NULL
);

-- Вопросы
CREATE TABLE questions (
    question_id UUID PRIMARY KEY,
    topic_id UUID NOT NULL,
    question_text TEXT NOT NULL,
    FOREIGN KEY (topic_id) REFERENCES topics(topic_id) ON DELETE CASCADE
);

-- Сессии тестов
CREATE TABLE test_sessions (
    session_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    topic_id UUID NOT NULL,
    session_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (topic_id) REFERENCES topics(topic_id) ON DELETE CASCADE
);

-- Аудио ответы
CREATE TABLE audio_answers (
    answer_id UUID PRIMARY KEY,
    session_id UUID NOT NULL,
    question_id UUID NOT NULL,
    audio_file_url VARCHAR(500) NOT NULL,
    transcript_text TEXT,
    FOREIGN KEY (session_id) REFERENCES test_sessions(session_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE
);

-- Отчёты анализа
CREATE TABLE analysis_reports (
    report_id UUID PRIMARY KEY,
    answer_id UUID UNIQUE NOT NULL,
    cefr_level VARCHAR(50),
    grammar_mistakes_json JSONB,
    vocabulary_json JSONB,
    recommendations TEXT,
    FOREIGN KEY (answer_id) REFERENCES audio_answers(answer_id) ON DELETE CASCADE
);

-- Словарь пользователя
CREATE TABLE user_vocabulary (
    entry_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    word VARCHAR(255) NOT NULL,
    definition TEXT,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Достижения
CREATE TABLE achievements (
    achievement_id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    icon_url VARCHAR(500)
);

-- Достижения пользователей
CREATE TABLE user_achievements (
    user_id UUID NOT NULL,
    achievement_id UUID NOT NULL,
    date_earned TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, achievement_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(achievement_id) ON DELETE CASCADE
);
