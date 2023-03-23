import React, { useState } from 'react';

function GitHubLoginButton() {
  const [userData, setUserData] = useState(null);
  const [accessToken, setAccessToken] = useState(null);

  const handleLogin = () => {
    const redirectURI = 'http://localhost:3000/auth/github/callback';
    const clientID = '656a76c5b00a5d6bb711';
    const scope = 'user';

    window.location = `https://github.com/login/oauth/authorize?client_id=${clientID}&scope=${scope}&redirect_uri=${redirectURI}`;
  };

  const handleCallback = async () => {
    const searchParams = new URLSearchParams(window.location.search);
    const code = searchParams.get('code');

    const response = await fetch('/auth/github', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ code }),
    });

    const data = await response.json();
    setUserData(data.user);
    setAccessToken(data.accessToken);
  };

  return (
    <>
      {accessToken ? (
        <p>Welcome, {userData.login}!</p>
      ) : (
        <button onClick={handleLogin}>Log in with GitHub</button>
      )}
    </>
  );
}

export default GitHubLoginButton;
