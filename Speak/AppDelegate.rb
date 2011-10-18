#
#  AppDelegate.rb
#  Speak
#

class AppDelegate
  attr_accessor :window
  attr_accessor :textField
  attr_accessor :add, :speak
  attr_accessor :tableView
  attr_accessor :voice

  def applicationDidFinishLaunching(a_notification)
    # Insert code here to initialize your application
    @words = []
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

  def speak(sender)
    index = tableView.selectedRow
    return unless tableView.isRowSelected(index)

    string = @words[index]

    index = voice.indexOfSelectedItem
    v   = "-v #{voice.itemObjectValueAtIndex(index)}" if index >= 0
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

end

