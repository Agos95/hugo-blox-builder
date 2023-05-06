import {hugoEnvironment} from '@params';

/* ---------------------------------------------------------------------------
 * GitHub API.
 * --------------------------------------------------------------------------- */

function printLatestRelease(selector, repo) {
  if (hugoEnvironment === 'production') {
    fetch('https://api.github.com/repos/' + repo + '/tags')
      .then((json) => {
        let release = json[0];
        document.querySelector(selector).append(' ' + release.name);
      }).catch((_, textStatus, error) => {
        let err = textStatus + ', ' + error;
        console.log('Request Failed: ' + err);
      })
  }
}

export {printLatestRelease};
