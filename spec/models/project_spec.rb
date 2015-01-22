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

    it "considers a project with no test to be done" do
      expect(project).to be_done
    end

    it "knows that a project with an incomplete test is not done" do
      project.tasks << task
      expect(project).not_to be_done
    end

    it "marks a project done if its tasks are done" do
      project.tasks << task
      task.mark_completed
      expect(project).to be_done
    end

    it "properly estimates a blank project" do
      expect(project.completed_velocity).to eq(0)
      expect(project.current_rate).to eq(0)
      expect(project.projected_days_remaining.nan?).to be_truthy
      expect(project).not_to be_on_schedule
    end
  end

  describe "estimates" do
    let(:project) { Project.new }
    let(:newly_done) { Task.new(size: 3, completed_at: 1.day.ago) }
    let(:old_done) { Task.new(size: 2, completed_at: 6.months.ago) }
    let(:small_not_done) { Task.new(size: 1) }
    let(:large_not_done) { Task.new(size: 4) }

    before(:example) do
      project.tasks = [newly_done, old_done, small_not_done, large_not_done]
    end

    #
    it "can calculate total size" do
      expect(project).to be_of_size(10)
      expect(project).to be_of_size(5).for_incomplete_tasks_only
    end
    #

    it "can calculate remaining size" do
      expect(project.remaining_size).to eq(5)
    end

    it "knows its velocity" do
      expect(project.completed_velocity).to eq(3)
    end

    it "knows its rate" do
      expect(project.current_rate).to eq(1.0 / 7) 
    end

    it "knows its projected time remaining" do
      expect(project.projected_days_remaining).to eq(35) 
    end

    it "knows if it is on schedule" do
      project.due_date = 1.week.from_now
      expect(project).not_to be_on_schedule
      project.due_date = 6.months.from_now
      expect(project).to be_on_schedule
    end
  end

  #
  it "stubs an object" do
    project = Project.new(name: "Project Greenlight")
    allow(project).to receive(:name) 
    expect(project.name).to be_nil 
  end
  #

  #
  it "stubs an object again" do
    project = Project.new(name: "Project Greenlight")
    allow(project).to receive(:name).and_return("Fred") 
    expect(project.name).to eq("Fred") 
  end
  #

  #
  it "stubs the class" do
    allow(Project).to receive(:find).and_return(
        Project.new(name: "Project Greenlight"))
    project = Project.find(1) 
    expect(project.name).to eq("Project Greenlight")
  end
#

#
  it "mocks an object" do
    mock_project = Project.new(name: "Project Greenlight")
    expect(mock_project).to receive(:name).and_return("Fred")
    expect(mock_project.name).to eq("Fred")
  end
#

#
  xit "stubs with multiple returns" do
    project = Project.new
    allow(project).to receive(:user_count).and_return(1, 2)
    assert_equal(1, project.user_count)
    assert_equal(2, project.user_count)
    assert_equal(2, project.user_count)
  end
#

  context "for my understanding" do
    it "generic doubles" do
      x = double(:fn => "Boti", :m => "Masik")
      expect(x.fn).to eq("Boti")
      expect(x.m).to eq("Masik")
      expect { x.asdsad }.to raise_error(Exception)
    end
    it "doubles as null objects aka spyes" do
      x = double.as_null_object
      expect{ x.asdsad }.to_not raise_error(Exception)
      x = spy
      expect{ x.asdsad }.to_not raise_error(Exception)
    end
    context "verifying" do
      context "doubles" do
        it "instances" do
          x = instance_double( Project, :name => "Boti")
          expect{ x.find_by_id }.to raise_error(Exception)
          expect{ x.name }.to_not raise_error(Exception)
        end
        it "classes" do
          x = class_double Project
          allow(x).to receive(:first).and_return(nil)
          expect{ x.asdsad }.to raise_error(Exception)
          expect{ x.first }.to_not raise_error(Exception)
        end
        it "instances allowing the dynamic methods to be stubbed" do
          x = object_double Project
          allow(x).to receive(:find_by_id).and_return(nil)
          expect{ x.find_by_id }.to_not raise_error(Exception)
          expect{ x.find_by_iddd }.to raise_error(Exception)
        end
      end
      context "spies" do
        it "instances" do
          x = instance_spy( Project)
          expect{ x.find_by_id }.to raise_error(Exception)
          expect{ x.name }.to_not raise_error(Exception)
        end
        it "classes" do
          x = class_spy Project
          expect{ x.asdsad }.to raise_error(Exception)
          expect{ x.first }.to_not raise_error(Exception)
        end
        it "instances allowing the dynamic methods to be stubbed" do
          x = object_spy Project
          expect{ x.find_by_id }.to_not raise_error(Exception)
          expect{ x.find_by_iddd }.to raise_error(Exception)
        end
      end
    end
  end

end
