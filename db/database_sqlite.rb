require "sqlite3"

class DB
  def initialize(file_name)
    @db = SQLite3::Database.new(file_name)
    @db.results_as_hash = true
    @db.execute "PRAGMA foreign_keys = ON;"
  end

  def execute(sql, args = [])
    begin
      return @db.execute(sql, args)
    rescue => e
      puts(e.message)
      return nil
    end
  end

  def init(name, defs)
    execute("drop table if exists #{name};")
    execute("create table #{name} (#{defs});")
  end

  def in(name)
    result = execute("pragma table_info(#{name});")
    if result.empty? then
      return nil
    end
    cols = result.collect { |row| row["name"] }.select { |col| col != "id" }
    if result.any? { |row| row["name"] == "id" && row["pk"] == 1 } then
      return Table.new(self, name, cols)
    else
      return View.new(self, name, cols)
    end
  end
end

class View
  def initialize(db, name, cols)
    @db = db
    @name = name
    @cols = cols
  end

  def all
    return @db.execute("select * from #{@name};")
  end

  def size
    result = @db.execute("select count(*) as count from #{@name} limit 1;")
    return result.first["count"]
  end

  def all_where(cond, args = [])
    return @db.execute("select * from #{@name} where #{cond};", args)
  end

  def one_where(cond, args = [])
    result = @db.execute("select * from #{@name} where #{cond} limit 1;", args)
    return result.first
  end
end

class Table < View
  def get(id)
    result = @db.execute("select * from #{@name} where id = ? limit 1;", [id])
    return result.first
  end

  def id_of(row)
    cond = @cols.collect { |col| "#{col} = ?" }.join(" and ")
    vals = @cols.collect { |col| row[col] }
    res = one_where(cond, vals)
    if res == nil then
      return nil
    end
    return res["id"]
  end

  def delete(id)
    @db.execute("delete from #{@name} where id = ?;", [id])
    return get(id) == nil
  end

  def set(id, row)
    cols = @cols.collect { |col| "#{col} = ?" }.join(", ")
    vals = @cols.collect { |col| row[col] }
    @db.execute("update #{@name} set #{cols} where id = ?;", vals + [id])
    return get(id)
  end

  def insert(row)
    existing_id = id_of(row)
    if existing_id != nil then
      return existing_id
    end
    vals = @cols.collect { |col| row[col] }
    @db.execute("
      insert into #{@name} (#{@cols.join(',')})
      values (#{(['?'] * @cols.size).join(',')});
    ", vals)
    return id_of(row)
  end
end
