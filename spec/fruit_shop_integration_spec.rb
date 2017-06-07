require 'spec_helper'

RSpec.describe "fruit_shop integration", type: :aruba do
  context "with valid options" do
    describe "when passed -h (help) flag" do
      before do
        run "fruit_shop -h"
      end

      it "ouputs watermelons option" do
        expect(last_command_started).to have_output /--watermelons COUNT/
      end

      it "ouputs rockmelons option" do
        expect(last_command_started).to have_output /--rockmelons COUNT/
      end

      it "ouputs pineapples option" do
        expect(last_command_started).to have_output /--pineapples COUNT/
      end
    end
  end

  context "with incorrect options" do
    describe "when given no options" do
      before do
        run "fruit_shop"
      end

      it "outputs an error message" do
        expect(last_command_started).to have_output(
          /Empty order, try -h for available options/
        )
      end

      it "exits with exit status 1" do
        expect(last_command_started).to have_exit_status 1
      end
    end

    describe "when given an order count less than 1" do
      before do
        run "fruit_shop --watermelons -1"
      end

      it "outputs an error message" do
        expect(last_command_started).to have_output(
          /Please enter a number greater than 0/
        )
      end

      it "exits with exit status 1" do
        expect(last_command_started).to have_exit_status 1
      end
    end
  end
end