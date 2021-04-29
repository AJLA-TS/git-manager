require 'git-manager'

RSpec.describe GitManager, type: :lib do
  context '#latest_tag' do
    context 'with ordinary tag names' do
      let(:tags) do
        %w[
          0.1
          0.1.1
          0.1.2
          0.1.3
          0.1.4
        ]
      end

      it 'returns the latest matching tagged branch' do
        ENV['DEPLOY_BRANCH'] = nil
        gm = GitManager.new
        expect(gm).to receive(:tags).and_return(tags)
        expect(gm.deploy_tag).to eq('0.1.4')
      end

      it 'returns the DEPLOY_BRANCH env var if set' do
        ENV['DEPLOY_BRANCH'] = 'test_branch'
        gm = GitManager.new
        expect(gm.deploy_tag).to eq('test_branch')
      end

      it 'raises an error if no matching tags and env var not set' do
        ENV['DEPLOY_BRANCH'] = nil
        gm = GitManager.new
        expect(gm).to receive(:tags).and_return([])
        expect do
          gm.deploy_tag
        end.to raise_error(RuntimeError, /create one and try again/)
      end
    end

    context 'when there is a weird tag name' do
      let(:tags) do
        %w[
          0.1
          0.1.1
          0.1.2
          0.1.3
          0.1.4
          2021.03.30
        ]
      end

      it 'raises an error because of the 2021 tag' do
        ENV['DEPLOY_BRANCH'] = nil
        gm = GitManager.new
        expect(gm).to receive(:tags).and_return(tags)
        expect do
          gm.deploy_tag
        end.to raise_error(RuntimeError, /looks like it has more than one digit/)
      end
    end
  end
end
