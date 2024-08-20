import { useEffect, useState } from "react"
import { followRequestAction, getFollowRequest } from "../lib/api"
import imgavatar from '../images/avatar.png'
import { Link } from "react-router-dom"

export default function FollowReq(){
    const [followrq ,setFollowRq] = useState([])
    useEffect(()=>{
        (async ()=>{
            const res = await getFollowRequest("pending")
            if(res[0]=== true){
                setFollowRq(res[1].res)
            }
        })()
    },[])
    const handleAccept= async (id) =>{
        const res = await followRequestAction(id,true)
        if(res[0] == true){
        setFollowRq( p => {
            const rem = p.filter(fq => fq.id != id)
            return rem
        })
    }
    }
    const handleReject= async (id) =>{
        const res = await followRequestAction(id,false)
        if(res[0] == true){
        setFollowRq( p => {
            const rem = p.filter(fq => fq.id != id)
            return rem
        })} 
    }
    return(
        <div>
            { followrq.length == 0 ? <div> No Follow Requests </div> :
                followrq.map(r => <div className=' flex justify-between gap-[10px] items-center p-2 border-black border-2 rounded-md'>
                    <div className="flex items-center gap-[10px]">
                    <img className='rounded-full w-[48px] h-[48px]' src={r.avatar ? r.avatar : imgavatar} />
                    <Link to={`/user/${r.user_id}`} >{r.user_name}</Link>
                    </div>
                    <div className="flex gap-[5px]">
                        <button onClick={() =>handleAccept(r.id)} className=" rounded-lg btn bg-green-500">accept</button>
                        <button onClick={() =>handleReject(r.id)} className=" rounded-lg btn bg-red-500">reject</button>
                    </div>
                </div>)
            }
       
        </div>
    )
}