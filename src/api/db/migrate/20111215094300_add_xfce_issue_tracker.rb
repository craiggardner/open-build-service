class AddXfceIssueTracker < ActiveRecord::Migration
  def self.up
    IssueTracker.find_or_create_by_name('bxo', :description => 'XFCE Bugzilla', :kind => 'bugzilla', :regex => 'bxo#(\d+)', :url => 'https://bugzilla.xfce.org/', :show_url => 'https://bugzilla.xfce.org/show_bug.cgi?id=@@@')
    Delayed::Job.enqueue IssueTrackersToBackendJob.new
  end

  def self.down
    it = IssueTracker.find_by_name('bxo')
    it.destroy if it
    Delayed::Job.enqueue IssueTrackersToBackendJob.new
  end
end
