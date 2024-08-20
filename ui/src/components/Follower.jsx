import { useEffect, useState } from "react"
import { getFollower } from "../lib/api"
import imgavatar from '../images/avatar.png'
import { Link } from "react-router-dom"

export default function Follower(){
    const [follower ,setFollower] = useState([])
    useEffect(()=>{
        (async ()=>{
            const res = await getFollower()
            if(res[0]=== true){
                setFollower(res[1].res)
            }
        })()
    },[])
    return(
        <div>
            { follower.length == 0 ? <div> No Followers </div> :
                follower.map(r => <div className=' flex  gap-[10px] items-center p-2 border-black border-2 rounded-md'>
                    <img className='rounded-full w-[48px] h-[48px]' src={r.avatar ? r.avatar : imgavatar} />
                    <Link to={`/user/${r.user_id}`} >{r.user_name}</Link>
                </div>)
            }
       
        </div>
    )
}