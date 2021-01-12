# encoding: utf-8

require 'yaml'
require "json"

class ConfigData
  class RawData
    attr_reader :current
    def self.push_data(v)
      return RawData.new(v) if v.instance_of?(Array) or v.instance_of?(Hash)
      return v
    end
    def initialize(raw)
      @current = nil
      if raw.instance_of?(Array)
        @current = []
        raw.each{|v|
          @current.push(RawData.push_data(v))
        }
      elsif raw.instance_of?(Hash)
        @current = {}
        raw.each{|k,v|
          @current[k] = RawData.push_data(v)
        }
      else
        # force string
        @current = raw
      end
    end
    private def pop_data(v)
      return v.to_o() if v.instance_of?(RawData)
      return v
    end
    def to_o()
      ret = nil
      if @current.instance_of?(Array)
        ret = []
        @current.each{|v|
          ret.push(pop_data(v))
        }
      elsif @current.instance_of?(Hash)
        ret = {}
        @current.each{|k,v|
          ret[k] = pop_data(v)
        }
      else
        ret = pop_data(@current)
      end
      return ret
    end
    def method_missing(name, *args)
      rname = name.to_s
      add_val = nil
      if rname[-1] == '='
        add_val = args.pop()
        rname = rname[0,rname.size-1]
      end
      if rname == "[]"
        key = args.pop()
        if !add_val.nil?
          @current = {} if @current.nil?
          if add_val.instance_of?(Array) or add_val.instance_of?(Hash)
            @current[key] = RawData.new(add_val)
          else
            @current[key] = add_val
          end
        end
        return @current[key] 
      end
      if !add_val.nil?
        add_val = add_val[0] if add_val.size == 1
        @current = {} if @current.nil?
        if add_val.instance_of?(Array) or add_val.instance_of?(Hash)
          @current[rname] = RawData.new(add_val)
        else
          if @current.instance_of?(Array) or @current.instance_of?(Hash)
            @current[rname] = add_val
          else
            @current = add_val
          end
        end
      end
      return nil if @current.nil?
      if @current.instance_of?(Array) or @current.instance_of?(Hash)
        return @current[rname]
      else
        return @current
      end
    end
  end
  def clear()
    @value = RawData.new(nil)
  end
  def initialize()
    clear()
  end
  def dumpYAML()
    return YAML.dump(@value.to_o())
  end
  def saveYAML(file)
    saveToFile(file,dumpYAML())
  end
  def loadYAML(str)
    if str == ""
      clear()
      return
    end
    raw = YAML.load(str)
    @value = RawData.new(raw)
  end
  def readYAML(file)
    loadYAML(loadFromFile(file))
  end
  def dumpJson()
    return JSON.generate(@value.to_o())
  end
  def saveJson(file)
    saveToFile(file,dumpJson())
  end
  def loadJson(str)
    if str == ""
      clear()
      return
    end
    raw = JSON.parse(str)
    @value = RawData.new(raw)
  end
  def readJson(file)
    loadJson(loadFromFile(file))
  end
  def method_missing(name, *args)
    return @value.send(name,args)
  end
  private
  def saveToFile(fname,data)
    File.open(fname,File::Constants::RDWR|File::Constants::CREAT){|f|
      f.flock(File::Constants::LOCK_EX)
      begin
        f.write(data)
      ensure
        f.flock(File::Constants::LOCK_UN)
      end
    }
  end
  def loadFromFile(fname)
    File.open(fname,File::Constants::RDONLY){|f|
      f.flock(File::Constants::LOCK_SH)
      begin
        return f.read()
      ensure
        f.flock(File::Constants::LOCK_UN)
      end
    }
    return nil
  end
end
