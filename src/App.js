import React, { Component } from 'react';

import GitHubLogin from 'react-github-login';

class App extends Component {

  render() {

    const onSuccessGithub = (response) => {
      console.log(response.code);
    } 

    return (
      <div className="App" align="center">
        <h1>LOGIN WITH GITHUB AND MICROSOFT</h1>

          {/*CLIENTID REDIRECTURI NOT CREATED YET*/}

          <GitHubLogin clientId="_"
            onSuccess={onSuccessGithub}
            buttonText="LOGIN WITH GITHUB"
            className="git-login"
            valid={true}
            redirectUri="_"
          />

          <br />
          <br />

          

        
    

      </div>
    );
  }
}

export default App;