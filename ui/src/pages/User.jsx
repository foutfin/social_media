import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { followRequest, getUserDetail } from '../lib/api';
import avatar from '../images/avatar.png'
import toast from 'react-hot-toast';
export default function User() {
    let { id } = useParams()
    const [status, setStatus] = useState("loading")
    const [userData, setUserData] = useState(undefined)
    const [ fr ,setFr] = useState(false)
    // 101929
    useEffect(() => {
        (async () => {
            const res = await getUserDetail(id)
            console.log(res)
            if (res[0] === true) {
                setUserData(res[1])
                setStatus("show")
                return
            }
            if (res[1].status == 404) {
                setStatus("notfound")
            }
        })()
    }, [])

    const handleFollowRequest = async () =>{
        const res = await followRequest(userData.res.user_id)
        if(res[0] == true){
            setFr(true)
            return
        }
        if(Array.isArray(res[1])){
            res[1].error.forEach(error => {
                toast.error(error)
            });
            return 
        }
        toast.error(res[1].error)
    }
    return (
        <div>
            {status === "loading" && <span>Loading ....</span>}
            {status === "notfound" && <h3>Post Not Found</h3>}
            {status === "show" && <div className='w-[40%] mx-auto'>
                <div className='mt-[40px] flex gap-[10px] items-center'>
                    <img className='w-[96px] h-[96px] rounded-full' src={userData.res.avatar ? userData.res.avatar:  avatar} />
                    <div className='flex flex-col gap-[10px]'>
                        <span className=' font-semibold text-2xl'>{userData.res.username}</span>
                        <span>{userData.res.bio}</span>
                    </div>
                </div>
                { userData.isFriend === true ? null : <div>
                        <button disabled={fr} onClick={handleFollowRequest} className='mt-[20px] btn bg-green-500 rounded-lg'>Send Request</button>
                    </div>}
            </div>}
        </div>
    )
}


