function App() {
  const [isRepoDropdownOpen, setIsRepoDropdownOpen] = React.useState(false);

  return (
    <div className="flex justify-center items-center min-h-screen bg-[#0A0A0A] p-4">
      <div className="w-[320px] bg-[#111111] rounded-xl overflow-hidden border border-[#00FF00] shadow-[0_0_10px_rgba(0,255,0,0.2)]">
        {/* Title Bar */}
        <div className="flex justify-between items-center px-3 py-2 bg-[#111111]">
          <div className="flex items-center">
            <div className="flex items-center bg-[#1a1a1a] rounded-full px-2 py-0.5">
              <div className="w-2 h-2 rounded-full bg-[#00FF00] mr-1"></div>
              <span className="text-[#00FF00] text-xs">in sync</span>
            </div>
          </div>
          <div className="flex space-x-2">
            <button className="text-[#00FF00] hover:text-[#00FF00]/80">
              <i className="fas fa-cog text-sm"></i>
            </button>
            <button className="text-[#00FF00] hover:text-[#00FF00]/80">
              <i className="fas fa-times text-sm"></i>
            </button>
          </div>
        </div>

        {/* Content */}
        <div className="p-4 space-y-4">
          <h1 className="text-[#00FF00] text-xl font-mono text-center tracking-[0.3em]">ACTIONWORKFLOW</h1>

          {/* Repository Search */}
          <div className="relative">
            <div className="relative">
              <input
                type="text"
                placeholder="Search repository..."
                className="w-full bg-[#1a1a1a] border border-[#00FF00] rounded px-3 py-2 text-[#00FF00] placeholder-[#00FF00]/50 focus:outline-none"
                onClick={() => setIsRepoDropdownOpen(!isRepoDropdownOpen)}
              />
              <i className="fas fa-search absolute right-3 top-3 text-[#00FF00]"></i>
            </div>

            {isRepoDropdownOpen && (
              <div className="absolute w-full mt-1 bg-[#1a1a1a] border border-[#00FF00] rounded z-10">
                {['user/repo-1', 'user/repo-2', 'user/repo-3'].map((repo, index) => (
                  <button
                    key={index}
                    className="w-full px-3 py-2 text-left text-[#00FF00] hover:bg-[#2a2a2a] flex items-center"
                  >
                    <i className="fas fa-history mr-2 text-xs"></i>
                    <span>{repo}</span>
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Branch and Commit Selection */}
          <div className="grid grid-cols-2 gap-3">
            <select className="bg-[#1a1a1a] border border-[#00FF00] rounded px-3 py-2 text-[#00FF00] focus:outline-none">
              <option value="">Select branch</option>
              <option value="main">main</option>
              <option value="develop">develop</option>
            </select>

            <select className="bg-[#1a1a1a] border border-[#00FF00] rounded px-3 py-2 text-[#00FF00] focus:outline-none">
              <option value="">Select commit</option>
              <option value="latest">Latest commit</option>
            </select>
          </div>

          {/* Action Buttons */}
          <div className="grid grid-cols-3 gap-2">
            <button className="bg-[#1a1a1a] border border-[#00FF00] rounded px-4 py-2 text-[#00FF00] hover:bg-[#2a2a2a]">
              Push
            </button>
            <button className="bg-[#1a1a1a] border border-[#00FF00] rounded px-4 py-2 text-[#00FF00] hover:bg-[#2a2a2a]">
              Pull
            </button>
            <select className="bg-[#1a1a1a] border border-[#00FF00] rounded px-2 py-2 text-[#00FF00] focus:outline-none">
              <option value="">Deploy to...</option>
              <option value="netlify">Netlify</option>
              <option value="vercel">Vercel</option>
              <option value="heroku">Heroku</option>
              <option value="digitalocean">DigitalOcean</option>
            </select>
          </div>
        </div>
      </div>
    </div>
  );
}