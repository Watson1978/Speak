#
#  AppDelegate.rb
#  Speak
#

require 'fileutils'
DATA_PATH = "~/Library/Application Support/Say/say.txt"

class AppDelegate
  attr_accessor :window
  attr_accessor :textField
  attr_accessor :tableView
  attr_accessor :comboBox

  def applicationDidFinishLaunching(a_notification)
    # Insert code here to initialize your application
    @words = []
    path = File.expand_path(DATA_PATH)
    if File.exist?(path)
      File.open(path) {|f|
        f.each_line do |item|
          @words << item
        end
      }
      tableView.reloadData
    end
  end

  #----------------------------------------
  # action methods
  def add(sender)
    if textField.stringValue.length > 0
      @words << textField.stringValue
      textField.stringValue = ""

      tableView.reloadData
    end
  end

  def delete(sender)
    index = tableView.selectedRow
    return unless tableView.isRowSelected(index)

    @words.delete_at(index)
    tableView.reloadData
  end

  def say(sender)
    index = tableView.selectedRow
    return unless tableView.isRowSelected(index)

    string = @words[index]

    index = comboBox.indexOfSelectedItem
    v   = "-v #{comboBox.itemObjectValueAtIndex(index)}" if index >= 0
    v ||= ""

    system "say #{v} \"#{string}\""
  end

  #----------------------------------------
  # dataSource of tableView
  def numberOfRowsInTableView(aTableView)
    return 0 if @words.nil?
    @words.size
  end

  def tableView(aTableView,
                objectValueForTableColumn:aTableColumn,
                row:rowIndex)
    @words[rowIndex]
  end
  
  #----------------------------------------
  # delegator
  def applicationShouldTerminate(sender)
    path = File.expand_path(DATA_PATH)
    dir = File.dirname(path)
    FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
    
    File.open(path, "w") {|f|
      @words.each do |item|
        f.puts item
      end
    }
    
    true
  end

end

