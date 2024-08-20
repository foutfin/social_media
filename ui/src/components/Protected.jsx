import { useEffect, useState } from "react";
import Navbar from "./Navbar"
import { useNavigate } from "react-router-dom";
import { aboutMe } from "../lib/api";

function Protected(prop){
    let navigate = useNavigate();
    const [loading , setLoading] = useState(true)
    const [ me ,setMe] = useState(undefined)
    useEffect(()=>{
        (async ()=>{
            const res = await aboutMe()
            if(res[0] == true){
                setLoading(false)
                setMe(res[1])
            }else{
                 navigate("/login");
            }
        })()
        
    },[])
    console.log(me)
    return(<div>
        { loading ? 
            <h3>Loading ....</h3>
            :
            <>
            <Navbar avatar={me.res.avatar}/>
            {prop.children}
            </>
        }
        
    </div>)
}
export default Protected;