# Note: I can access my database with DB[:conn]  

class Student
  
  attr_accessor :name, :grade
  attr_reader :id # it's not the responsiblity of ruby to manage this attribute; we will use sql to populate this field with its table's primary key value

  #@@all = []

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
    #self.class.all << self
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
      SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students;
      SQL
      DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?);
    SQL
    DB[:conn].execute(sql, self.name, self.grade)

    #? why index [0][0] - is this just an idiosyncratic property of sql data structure(row,column)... like matrix?
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  # Implementing keyboard arguments
  def self.create(name:, grade:)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

end
