#
#  AppDelegate.rb
#  Speak
#

require 'fileutils'
DATA_PATH = "~/Library/Application Support/Say/say.txt"

class AppDelegate
  attr_accessor :window
  attr_accessor :textField # outlet: Text Field
  attr_accessor :tableView # outlet: Table View
  attr_accessor :comboBox  # outlet: Combo Box

  def applicationDidFinishLaunching(a_notification)
    # Insert code here to initialize your application
    @words = []
    path = File.expand_path(DATA_PATH)
    if File.exist?(path)
      File.open(path) {|f|
        f.each do |item|
          @words << item
        end
      }
      tableView.reloadData()
    end
  end

  #----------------------------------------
  def add(sender)
    text = textField.stringValue()
    if text.length > 0
      @words << text
      textField.setStringValue("")

      tableView.reloadData()
    end
  end

  def delete(sender)
    index = tableView.selectedRow()

    if index >= 0
      @words.delete_at(index)
      tableView.reloadData()
    end
  end

  def say(sender)
    index = tableView.selectedRow()

    if index >= 0
      string = @words[index]

      index = comboBox.indexOfSelectedItem()
      v = ""
      if index >= 0
        v = "-v #{comboBox.itemObjectValueAtIndex(index)}"
      end

      system "say #{v} \"#{string}\""
    end
  end

  #----------------------------------------
  def numberOfRowsInTableView(aTableView)
    if @words.nil?
      return 0
    end

    return @words.size
  end

  def tableView(aTableView,
                objectValueForTableColumn:aTableColumn,
                row:rowIndex)
    return @words[rowIndex]
  end

  #----------------------------------------
  def applicationShouldTerminate(sender)
    path = File.expand_path(DATA_PATH)
    dir = File.dirname(path)
    if !Dir.exist?(dir)
      FileUtils.mkdir_p(dir)
    end

    File.open(path, "w") {|f|
      @words.each do |item|
        f.puts item
      end
    }

    return true
  end

end
