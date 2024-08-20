import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import {
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";
import Signup from './pages/signup';
import Login from './pages/login';
import Protected from './components/Protected';
import New from './pages/new';
import Post from './pages/Post';
import User from './pages/User';
import Profile from './pages/Profile';
import Search from './pages/search';
import Home from './pages/home';
import { Toaster } from 'react-hot-toast';
import EditPost from './components/EditPost';
import EditUser from './pages/EditUser';

const router = createBrowserRouter([
  {
    path: "/",
    element: <Signup />,
  },
  {
    path: "/login",
    element: <Login />
  },
  {
    path: "/home",
    element: <Protected>
      <Home/>
    </Protected>
  },
  {
    path: "/new",
    element: <Protected>
      <New />
    </Protected>
  },
  {
    path: "/post/:id",
    element: <Protected>
      <Post />
    </Protected>
  },
  {
    path: "/user/:id",
    element: <Protected>
      <User />
    </Protected>
  },
  {
    path: "/profile",
    element: <Protected>
      <Profile />
    </Protected>
  },
  {
    path: "/search",
    element: <Protected>
      <Search />
    </Protected>
  },
  {
    path: "/setting",
    element: <Protected>
      <EditUser />
    </Protected>
  }
]);

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <div>
      <div><Toaster position="top-right"/></div>
      <RouterProvider router={router} />
    </div>
  </StrictMode>,
)