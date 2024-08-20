import { Link } from "react-router-dom";
import { logout } from "../lib/api";
import { useNavigate } from "react-router-dom";
import imgavatar from '../images/avatar.png'
import { useState } from "react";


function Navbar({avatar}){
    const [query , setQuery] = useState("")
    let navigate = useNavigate();

    const handleLogout = async () =>{
      const res = await logout()
      if(res[0] == true ){
        navigate("/")
      }
    }
    const handleSearch =()=>{
      if(!query) return;
      navigate(`/search?q=${query}`)
    }


    return(<div className="navbar bg-base-100">
        <div className="flex-1">
          <Link to="/home" className="btn btn-ghost text-xl">Flow</Link>
        </div>
        <div className="flex-none gap-2">
          <div className="form-control">
            <input value={query} onChange={e=>setQuery(e.target.value)} type="text" placeholder="Search" className="input input-bordered w-24 md:w-auto" />
            
          </div>
          <button onClick={handleSearch} className="btn">Search</button>
          <div>
            <Link to="/new" className="btn bg-green-500">+ New Post</Link>
          </div>
          <div className="dropdown dropdown-end">
            <div tabIndex={0} role="button" className="btn btn-ghost btn-circle avatar">
              <div className="w-10 rounded-full">
                <img
                  src={ avatar ? avatar:  imgavatar  } />
              </div>
            </div>
            <ul
              tabIndex={0}
              className="menu menu-sm dropdown-content bg-base-100 rounded-box z-[1] mt-3 w-52 p-2 shadow">
              <li>
                <Link to="/profile" className="justify-between">
                  Profile
                </Link>
              </li>
              <li><Link to="/setting">Settings</Link></li>
              <li><button onClick={handleLogout}>Logout</button></li>
            </ul>
          </div>
        </div>
      </div>)
}
export default Navbar;