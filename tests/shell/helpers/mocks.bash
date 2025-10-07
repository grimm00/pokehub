#!/usr/bin/env bash

# Mock functions for external commands

# Mock git remote to return specific URL
mock_git_remote() {
  local url="$1"
  git() {
    if [ "$1" = "remote" ] && [ "$2" = "get-url" ]; then
      echo "$url"
    else
      command git "$@"
    fi
  }
  export -f git
}

# Mock gh repo view to return specific data
mock_gh_repo_view() {
  local owner="$1"
  local repo="$2"
  gh() {
    if [ "$1" = "repo" ] && [ "$2" = "view" ]; then
      cat <<EOF
{
  "owner": {"login": "$owner"},
  "name": "$repo",
  "nameWithOwner": "$owner/$repo"
}
EOF
    else
      command gh "$@"
    fi
  }
  export -f gh
}

# Mock docker commands for deployment testing
mock_docker_success() {
  docker() {
    case "$1" in
      "info")
        echo "Docker info"
        return 0
        ;;
      "pull")
        echo "Pulling: $2"
        return 0
        ;;
      "stop"|"rm")
        echo "$1: $2"
        return 0
        ;;
      "run")
        echo "Running container"
        return 0
        ;;
      "ps")
        echo "NAMES    STATUS    PORTS"
        echo "$2      Up        0.0.0.0:80->80/tcp"
        return 0
        ;;
      *)
        return 0
        ;;
    esac
  }
  export -f docker
}

# Mock docker to simulate failure
mock_docker_failure() {
  docker() {
    return 1
  }
  export -f docker
}

# Mock curl for health checks
mock_curl_success() {
  curl() {
    return 0
  }
  export -f curl
}

# Mock curl to simulate failure
mock_curl_failure() {
  curl() {
    return 1
  }
  export -f curl
}

# Mock sleep to speed up tests
mock_sleep() {
  sleep() {
    return 0
  }
  export -f sleep
}

# Mock docker-compose for Pokehub deployment
mock_docker_compose_success() {
  docker-compose() {
    case "$1" in
      "up")
        echo "Starting services..."
        return 0
        ;;
      "down")
        echo "Stopping services..."
        return 0
        ;;
      "ps")
        echo "SERVICE          STATUS"
        echo "pokedex-backend  Up"
        echo "pokedex-frontend Up"
        return 0
        ;;
      *)
        return 0
        ;;
    esac
  }
  export -f docker-compose
}

# Mock redis-cli for health checks
mock_redis_cli_success() {
  redis-cli() {
    if [ "$1" = "ping" ]; then
      echo "PONG"
      return 0
    fi
    return 0
  }
  export -f redis-cli
}

# Mock redis-cli failure
mock_redis_cli_failure() {
  redis-cli() {
    return 1
  }
  export -f redis-cli
}

# Mock Python for Pokehub backend
mock_python_success() {
  python() {
    case "$1" in
      "--version"|"-V")
        echo "Python 3.9.0"
        return 0
        ;;
      "-m")
        # Mock python -m backend.app
        echo "Starting Flask app..."
        return 0
        ;;
      *)
        return 0
        ;;
    esac
  }
  export -f python
}

# Mock Python failure
mock_python_failure() {
  python() {
    return 1
  }
  export -f python
}

# Mock npm for frontend operations
mock_npm_success() {
  npm() {
    case "$1" in
      "test")
        echo "Tests passed"
        return 0
        ;;
      "run")
        if [ "$2" = "dev" ]; then
          echo "Starting dev server..."
        elif [ "$2" = "build" ]; then
          echo "Building..."
        fi
        return 0
        ;;
      "install")
        echo "Installing dependencies..."
        return 0
        ;;
      *)
        return 0
        ;;
    esac
  }
  export -f npm
}

# Mock npm failure
mock_npm_failure() {
  npm() {
    return 1
  }
  export -f npm
}

# Mock psql for database operations
mock_psql_success() {
  psql() {
    if [[ "$@" =~ "-c" ]]; then
      echo "Query executed"
      return 0
    fi
    return 0
  }
  export -f psql
}

# Mock psql failure
mock_psql_failure() {
  psql() {
    return 1
  }
  export -f psql
}

# Mock all Pokehub services as healthy
mock_pokehub_services_healthy() {
  docker() {
    case "$1" in
      "info") return 0 ;;
      "ps") echo "pokedex-backend Up"; echo "pokedex-frontend Up"; return 0 ;;
      *) return 0 ;;
    esac
  }
  curl() { return 0; }
  redis-cli() { echo "PONG"; return 0; }
  psql() { return 0; }
  export -f docker curl redis-cli psql
}

# Mock all Pokehub services as unhealthy
mock_pokehub_services_unhealthy() {
  docker() { return 1; }
  curl() { return 1; }
  redis-cli() { return 1; }
  psql() { return 1; }
  export -f docker curl redis-cli psql
}

# Restore original commands
restore_commands() {
  unset -f git gh docker curl sleep docker-compose redis-cli python npm psql 2>/dev/null || true
}
