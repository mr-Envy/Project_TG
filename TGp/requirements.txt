# TGp — Question Paper Generator

TGp (temporary project name) is a question paper generation system designed to
generate multiple distinct question papers from a centralized question bank.

The initial prototype focuses on generating different question papers for
students taking the same examination. The long-term concept can be extended
towards secure examination-paper generation and distribution.

---

## 1. Project Vision

The initial TGp prototype is based on three core ideas:

1. Maintain a centralized question bank.
2. Define an examination using configurable requirements.
3. Generate multiple different question papers satisfying the same
   examination requirements.

For example, an examination may require:

- 50 questions
- A specified difficulty level
- A particular distribution across subjects
- A particular distribution across topics
- 50 different versions of the same examination

TGp will generate the required number of papers while maintaining the
specified constraints.

The generated papers can then be randomly assigned to students.

---

# 2. Current Scope — TGp v1

TGp v1 will support:

- A centralized question bank
- Subjects
- Topics
- Questions
- Difficulty levels
- CSV-based question import
- Adding individual questions
- Modifying individual questions
- Removing individual questions
- Examination configuration
- Subject distribution
- Topic distribution
- Question selection
- Randomized paper generation
- Generation of multiple versions of the same examination
- Final question-paper generation
- Question-paper export
- Random assignment of generated papers to student IDs

The first implementation will use:

- Python
- SQLite
- SQL
- CSV

No web framework, AI system, authentication system, or distributed
architecture is required for the initial prototype.

---

# 3. High-Level Architecture

The current architecture is:

    Question Bank
          |
          v
    generator.py
          |
          v
    Multiple Question Sets
          |
          v
    question_paper.py
          |
          v
    Generated Question Papers
          |
          v
    assignment.py
          |
          v
    Student -> Paper Assignment


The database layer is shared by the appropriate modules:

    schema.sql
          |
          v
    SQLite Database
          ^
          |
    connection.py


---

# 4. Project Structure

    TGp/
    │
    ├── data/
    │   └── .gitkeep
    │
    ├── docs/
    │   └── ARCHITECTURE.md
    │
    ├── src/
    │   │
    │   ├── assignment/
    │   │   └── assignment.py
    │   │
    │   ├── database/
    │   │   ├── connection.py
    │   │   └── schema.sql
    │   │
    │   ├── generator/
    │   │   └── generator.py
    │   │
    │   ├── question_bank/
    │   │   └── question_bank.py
    │   │
    │   └── question_paper/
    │       └── question_paper.py
    │
    ├── tests/
    │   ├── test_generator.py
    │   └── test_question_bank.py
    │
    ├── README.md
    └── requirements.txt

The structure may grow as new requirements are identified. Empty modules or
directories should not be created merely for convention.

---

# 5. Module Responsibilities

## 5.1 `database/schema.sql`

`schema.sql` is the blueprint for the database.

It defines:

- Tables
- Columns
- Data types
- Primary keys
- Foreign keys
- Constraints
- Relationships

The initial Question Bank database will contain three tables:

    subjects
        |
        v
    topics
        |
        v
    questions

The actual database data must not be hardcoded into the schema.

---

## 5.2 `database/connection.py`

`connection.py` manages access to the SQLite database.

Responsibilities:

- Create the database if required
- Open database connections
- Load/execute the schema during initialization
- Provide connections to other modules
- Handle connection cleanup

`connection.py` should not contain question-selection logic.

Conceptually:

    Python module
          |
          v
    connection.py
          |
          v
    SQLite database

---

# 6. Question Bank

## 6.1 Database Structure

The initial Question Bank consists of three tables.

### `subjects`

Stores subjects available in the question bank.

Fields:

- `subject_id`
- `subject_name`

---

### `topics`

Stores topics belonging to subjects.

Fields:

- `topic_id`
- `subject_id`
- `topic_name`

Relationship:

    Subject 1 ---- N Topics

---

### `questions`

Stores individual questions.

Current fields:

- `question_id`
- `question_text`
- `topic_id`
- `difficulty`
- `correct_option`

The question subject can be obtained through its topic.

Relationship:

    Topic 1 ---- N Questions

---

# 7. `question_bank.py`

`question_bank.py` is responsible for managing question-bank data.

Responsibilities include:

### Import

Import questions from CSV files.

Initial supported format:

    CSV only

The import process should validate the input before inserting data into
the database.

---

### CRUD Operations

The module should support:

- Add a question
- Retrieve a question
- Update a question
- Delete a question

---

### Retrieval and Filtering

The module should eventually support operations such as:

- Get questions by subject
- Get questions by topic
- Get questions by difficulty
- Get combinations of the above

Example:

    Get medium-difficulty questions
    from the Mechanics topic.

---

# 8. Generator

## `generator.py`

`generator.py` is the core TGp generation engine.

Its job is to take examination requirements and select questions from the
Question Bank.

It must not be responsible for final document formatting or exporting.

---

## 8.1 Generator Inputs

The current planned inputs are:

### Paper name

Example:

    Physics Midterm Examination

### Number of questions

Example:

    50

### Difficulty level

Example:

    Medium

The exact difficulty model will be finalized during implementation.

---

### Subject distribution

Defines how questions should be distributed among subjects.

Example:

    Physics:   20
    Chemistry: 15
    Biology:   15

or another agreed representation.

---

### Topic distribution

Defines how questions should be distributed among topics.

Example:

    Mechanics:       10
    Thermodynamics:   5
    Organic Chemistry: 15

The exact interaction between subject and topic distribution must be
defined before implementation.

---

### Selection for each

Defines the required number/weight of questions for the configured
subjects/topics.

This must be designed so that the generator can determine exactly how many
questions to select from each required category.

---

### Number of papers

Defines how many different versions of the same examination should be
generated.

Example:

    Number of papers = 50

The generator should produce:

    Paper 001
    Paper 002
    ...
    Paper 050

All papers must satisfy the same examination requirements.

---

# 9. Paper Generation

The generator must produce multiple question sets.

For example:

    Examination:
        50 questions
        50 versions

The generator produces:

    Set 001
    Set 002
    Set 003
    ...
    Set 050

Each set should satisfy the configured:

- Question count
- Subject distribution
- Topic distribution
- Difficulty requirements

The exact rules for how different two generated papers must be will be
defined during implementation.

---

# 10. Randomization

Randomization is a core part of TGp.

The system should avoid simply generating identical papers repeatedly.

The generator should eventually support deterministic randomization using a
seed.

Conceptually:

    Requirements + Seed
            |
            v
       Paper Set

Using the same requirements and seed should reproduce the same result.

Different seeds should allow different question selections.

The exact seed implementation will be defined when the generator is built.

---

# 11. `question_paper.py`

`question_paper.py` is responsible for turning a selected question set into
the final question paper.

Its responsibilities include:

- Ordering questions
- Numbering questions
- Formatting the paper
- Adding the paper name
- Formatting answer choices
- Adding examination instructions
- Producing the final document
- Exporting the paper

The generator decides:

    WHICH questions?

`question_paper.py` decides:

    HOW those questions become the final paper.

Potential export formats may include:

- PDF
- DOCX
- HTML

The initial export format will be decided during implementation.

---

# 12. `assignment.py`

`assignment.py` handles assignment of generated papers to students.

After papers are generated:

    Paper 001
    Paper 002
    ...
    Paper 050

and student IDs are provided:

    Student 001
    Student 002
    ...
    Student 050

the assignment module randomly maps students to generated papers.

Example:

    Student 001 -> Paper 037
    Student 002 -> Paper 004
    Student 003 -> Paper 019

The assignment should be stored separately from the Question Bank.

---

# 13. Separate Databases

The Question Bank and student-paper assignment data should be logically
separated.

Initial conceptual design:

    Question Bank DB
        |
        ├── subjects
        ├── topics
        └── questions


    Assignment / Generated Paper DB
        |
        ├── generated papers
        ├── paper information
        └── student -> paper assignments

The exact schema of the second database will be designed after the
Question Bank and generator are implemented.

---

# 14. Data Flow

The complete TGp v1 flow is:

    1. Question bank is populated
             |
             v
    2. User provides examination requirements
             |
             v
    3. generator.py retrieves suitable questions
             |
             v
    4. generator.py creates multiple different question sets
             |
             v
    5. question_paper.py creates the final papers
             |
             v
    6. Generated papers are stored
             |
             v
    7. Student IDs are provided
             |
             v
    8. assignment.py randomly assigns papers
             |
             v
    9. Assignment information is stored

---

# 15. Development Order

Development should proceed in the following order.

## Phase 1 — Database

1. Finalize Question Bank schema.
2. Implement `schema.sql`.
3. Implement `connection.py`.
4. Create and test the SQLite database.
5. Verify relationships and constraints.

---

## Phase 2 — Question Bank

1. Define the CSV format.
2. Implement CSV validation.
3. Implement CSV import.
4. Implement question insertion.
5. Implement question retrieval.
6. Implement question modification.
7. Implement question deletion.
8. Implement filtering by subject/topic/difficulty.
9. Add tests.

---

## Phase 3 — Generator

1. Define the examination configuration.
2. Define subject distribution rules.
3. Define topic distribution rules.
4. Define difficulty rules.
5. Define question-selection algorithm.
6. Implement randomization.
7. Implement seed handling.
8. Generate one paper.
9. Generate multiple papers.
10. Validate every generated paper.
11. Add tests.

---

## Phase 4 — Question Paper

1. Define the internal paper representation.
2. Define question ordering.
3. Define paper formatting.
4. Implement final paper construction.
5. Implement export.
6. Test generated documents.

---

## Phase 5 — Assignment

1. Define student input format.
2. Define assignment database structure.
3. Store generated paper information.
4. Implement randomized paper assignment.
5. Prevent duplicate assignment when required.
6. Store Student ID -> Paper ID mapping.
7. Add tests.

---

## Phase 6 — Integration

Connect all modules:

    Question Bank
          ↓
      Generator
          ↓
    Question Paper
          ↓
      Assignment

Test the entire pipeline using a realistic examination.

---

# 16. Testing Requirements

Each major module must have independent tests.

At minimum, test:

### Question Bank

- Valid CSV import
- Invalid CSV rejection
- Adding questions
- Updating questions
- Deleting questions
- Retrieving questions
- Subject filtering
- Topic filtering
- Difficulty filtering

### Generator

- Correct number of questions
- Correct subject distribution
- Correct topic distribution
- Correct difficulty
- No duplicate questions within a paper
- Multiple papers are generated
- Same seed produces reproducible results
- Invalid requirements are rejected

### Question Paper

- Correct number of questions
- Correct numbering
- Correct formatting
- Correct export
- Valid output file

### Assignment

- Every required student receives a paper
- Assignment is randomized
- A paper is not assigned more times than permitted
- Student-paper mapping is correctly stored

---

# 17. Error Handling

The system must not silently generate an invalid paper.

For example, if the user requests:

    20 Mechanics questions

but the Question Bank contains only:

    12 Mechanics questions

the generator must detect the problem.

It should report a meaningful error instead of generating an incomplete
paper.

Similar validation should exist for:

- Invalid subject
- Invalid topic
- Invalid difficulty
- Invalid distribution
- Insufficient questions
- Invalid number of papers
- Invalid CSV data

---

# 18. Git and Collaboration

The project is intended to be developed using Git and hosted on GitHub.

Do not commit:

- Virtual environments
- Local SQLite databases
- Temporary files
- Generated examination papers
- Student assignment data
- Secrets
- Environment files

The repository should contain source code, schema definitions, tests,
documentation, and other reproducible project files.

---

# 19. Coding Principles

### Keep responsibilities separate

Do not put database logic into the generator.

Do not put generation logic into the question-paper exporter.

Do not put assignment logic into the generator.

Use the following boundaries:

    connection.py
        Database access

    question_bank.py
        Question Bank operations

    generator.py
        Question selection and generation

    question_paper.py
        Final paper construction/export

    assignment.py
        Student-paper assignment

---

### Avoid premature complexity

Do not introduce technologies simply because they may be useful later.

The initial implementation should remain:

    Python
    SQLite
    SQL
    CSV

Future technologies can be introduced when the project requirements
justify them.

---

# 20. Future Direction

TGp is the initial prototype of a larger concept.

A possible future direction is TGM2, where an AI layer can select questions
based on student performance, strengths, weaknesses, and goals.

A further direction is TGM3, where question papers are generated separately
for examination centres using centre-specific generation mechanisms.

The TGM3 concept is intended to reduce the period during which a complete
question paper exists before an examination.

These systems are **not part of the current TGp v1 implementation**.

The current priority is to build a reliable question-paper generation
engine first.

---

# 21. Future Technology Migration

TGp v1 uses SQLite because it is simple and appropriate for the prototype.

If the system evolves into a centralized, multi-user service, the database
can be migrated to a server-based relational database such as PostgreSQL.

The application should therefore avoid unnecessarily coupling business
logic to SQLite-specific behavior.

The conceptual data model should remain portable.

---

# 22. Current Development Principle

Build the project incrementally.

Do not attempt to implement the entire system at once.

The immediate development sequence is:

    Database Schema
          ↓
    Database Connection
          ↓
    Question Bank
          ↓
    Generator
          ↓
    Question Paper
          ↓
    Assignment
          ↓
    Integration
          ↓
    Future Extensions

Every stage should be tested before moving to the next major stage.

---

# 23. Project Status

Current status:

- [x] Project concept defined
- [x] TGp v1 scope defined
- [x] Initial architecture defined
- [x] Module responsibilities defined
- [x] Initial directory structure created
- [x] SQLite selected for prototype
- [x] Question Bank tables identified
- [ ] Finalize database schema
- [ ] Implement database connection
- [ ] Implement Question Bank
- [ ] Implement CSV import
- [ ] Implement generator
- [ ] Implement randomization
- [ ] Implement multiple-paper generation
- [ ] Implement question-paper generation
- [ ] Implement export
- [ ] Implement assignment
- [ ] Implement integration tests
- [ ] Complete TGp v1

---

# 24. First Development Task

The first implementation task is:

**Finalize and implement `src/database/schema.sql`.**

The initial database should contain:

    subjects
    topics
    questions

No additional tables should be introduced until there is a demonstrated
requirement for them.

Once the schema is finalized, implement `connection.py` to create/load the
SQLite database and make it available to the rest of the application.