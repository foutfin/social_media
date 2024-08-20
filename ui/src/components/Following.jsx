import { useEffect, useState } from "react"
import { getFollowing, unfollow } from "../lib/api"
import imgavatar from '../images/avatar.png'
import { Link } from "react-router-dom"

export default function Following(){
    const [following ,setFollowing] = useState([])
    useEffect(()=>{
        (async ()=>{
            const res = await getFollowing()
            if(res[0]=== true){
                setFollowing(res[1].res)
            }
        })()
    },[])

    const handleUnfollow= async (id) =>{
        const res = await unfollow(id)
        if(res[0] == true){
            setFollowing( p => {
            const rem = p.filter(fq => fq.user_id != id)
            console.log(rem)
            return rem
        })} 
    }
    return(
        <div>
            { following.length == 0 ? <div> No Following </div> :
                following.map(r => <div key={r.user_id} className=' flex justify-between  gap-[10px] items-center p-2 border-black border-2 rounded-md'>
                    <div className="flex items-center gap-[10px]">
                    <img className='rounded-full w-[48px] h-[48px]' src={r.avatar ? r.avatar : imgavatar} />
                    <Link to={`/user/${r.user_id}`} >{r.user_name}</Link>
                    </div>
                    <div>
                        <button onClick={()=>handleUnfollow(r.user_id)} className="btn bg-red-500 rounded-lg">Unfollow</button>
                        </div>
                </div>)
            }
        </div>
    )
}