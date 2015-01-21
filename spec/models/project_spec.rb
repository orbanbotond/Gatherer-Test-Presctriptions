#---
# Excerpted from "Rails 4 Test Prescriptions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/nrtest2 for more book information.
#---
require 'rails_helper' 

RSpec.describe Project do 
  describe "initialization" do
    let(:project) { Project.new }
    let(:task) { Task.new }
    it "considers a project with no tasks to be done" do 
      expect(project.done?).to be_truthy 
    end
    it "knows that a project with an incomplete task is not done" do
      project.tasks << task
      expect(project).to_not be_done
    end
  end
end