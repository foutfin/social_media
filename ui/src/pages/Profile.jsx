import { useEffect, useState } from 'react';
import { aboutMe, archivePost, deletePost, getPosts, unarchivePost } from '../lib/api';
import avatar from '../images/avatar.png'
import { useNavigate } from "react-router-dom";
import Follower from '../components/Follower';
import Following from '../components/Following';
import FollowReq from '../components/FollowReq';
import EditPost from '../components/EditPost';

export default function Profile() {
    let navigate = useNavigate();

    const [status, setStatus] = useState("loading")
    const [userData, setUserData] = useState(undefined)
    const [posts, setPosts] = useState(undefined)
    const [archive, setArchive] = useState(false)
    const [filter, setFilter] = useState("all")
    useEffect(() => {
        (async () => {
            const res = await aboutMe()
            if (res[0] === true) {
                const postres = await getPosts(10, 1, "date", archive, "all")
                setUserData(res[1].res)
                setPosts(postres[1])
                setStatus("show")
                return
            }
            if (res[1].status == 404) {
                setStatus("notfound")
            }
            if (res[1].status == 401) {
                navigate("/login")
            }
        })()
    }, [])

    const handlePage = async (page) => {
        const postres = await getPosts(10, page, "date", archive, filter)
        setPosts(postres[1])
    }

    const handleArchive = async () => {
        if (archive == true) {
            const postres = await getPosts(10, 1, "date", false, "all")
            if (postres[0] == true) {
                setPosts(postres[1])
                setArchive(false)
            }
            return
        }
        const postres = await getPosts(10, 1, "date", true, "all")
        if (postres[0] == true) {
            setPosts(postres[1])
            setArchive(true)
        }
    }

    const handleType = async (type) => {
        const postres = await getPosts(10, 1, "date", archive, type)
        if (postres[0] == true) {
            setPosts(postres[1])
            setFilter(type)
        }
    }

    const handleArchivePost = async (id) => {
        const res = await archivePost(id)
        if (res[0] === true) {
            setPosts(p => {
                const rem = p.res.filter(fq => fq.id != id)
                return { ...p, res: rem }
            })
        }
    }
    const handleUnArchivePost = async (id) => {
        const res = await unarchivePost(id)
        if (res[0] === true) {
            setPosts(p => {
                const rem = p.res.filter(fq => fq.id != id)
                return { ...p, res: rem }
            })
        }
    }

    const handleDeletePost = async (id) => {
        const res = await deletePost(id)
        if (res[0] === true) {
            setPosts(p => {
                const rem = p.res.filter(fq => fq.id != id)
                return { ...p, res: rem }
            })
        }
    }


    return (
        <div>
            {status === "loading" && <span>Loading ....</span>}
            {status === "notfound" && <h3>Post Not Found</h3>}
            {status === "show" &&
                <div className='w-[40%] mx-auto mb-[40px]'>

                    <dialog id="followers" className="modal">
                        <div className="modal-box">
                            <Follower />
                            <div className="modal-action">
                                <form method="dialog">
                                    <button className="btn">Close</button>
                                </form>
                            </div>
                        </div>
                    </dialog>

                    <dialog id="followrq" className="modal">
                        <div className="modal-box">
                            <FollowReq />
                            <div className="modal-action">
                                <form method="dialog">
                                    <button className="btn">Close</button>
                                </form>
                            </div>
                        </div>
                    </dialog>

                    <dialog id="following" className="modal">
                        <div className="modal-box">
                            <Following />
                            <div className="modal-action">
                                <form method="dialog">
                                    <button className="btn">Close</button>
                                </form>
                            </div>
                        </div>
                    </dialog>

                    <div className='mt-[40px] flex gap-[10px] items-center'>
                        <img className='w-[96px] h-[96px] rounded-full' src={userData.avatar ? userData.avatar : avatar} />
                        <div className='flex flex-col gap-[10px]'>
                            <div className='flex gap-[10px]'>
                            <span className=' font-semibold text-2xl'>{userData.first_name}</span>
                            <span className=' font-semibold text-2xl'>{userData.last_name}</span>
                            </div>
                            <span className=''>{userData.username}</span>
                            <span>{userData.bio}</span>
                        </div>

                    </div>
                    <div className='flex gap-[10px]'>
                        <button className="btn" onClick={() => document.getElementById('followers').showModal()}>Followers</button>
                        <button className="btn" onClick={() => document.getElementById('following').showModal()}>Following</button>
                        <button className="btn" onClick={() => document.getElementById('followrq').showModal()}>FollowRequest</button>
                    </div>
                    <div className='mt-[40px] border-2 border-black'></div>
                    <div className='mt-[20px] flex gap-[5px]'>
                        <button onClick={()=>handleType("archive")} style={filter === "archive" ? { backgroundColor: "#000", color: "#fff" } : {}} className='btn rounded-lg'>Archived</button>
                        <button onClick={()=>handleType("all")} style={filter === "all" ? { backgroundColor: "#000", color: "#fff" } : {}} className='btn rounded-lg'>Both</button>
                        <button onClick={()=>handleType("text")} style={filter === "text" ? { backgroundColor: "#000", color: "#fff" } : {}} className='btn rounded-lg'>Text</button>
                        <button onClick={()=>handleType("media")} style={filter === "media" ? { backgroundColor: "#000", color: "#fff" } : {}} className='btn rounded-lg'>Media</button>
                    </div>
                    {posts.res?.length == 0 ? <h3 className='mt-[20px] text-center'>No posts </h3> :
                        <div>
                            <div className='mt-[20px] flex flex-col gap-[20px]'>
                                {posts.res?.map(p => <div className='p-4 border-[1px] border-black shadow-md shadow-gray-900/10 flex flex-col '>
                                    <dialog id={`dialog-${p.id}`} className="modal">
                                        <div className="modal-box">
                                            <EditPost caption={p.caption} body={p.body} id={p.id} />
                                            <div className="modal-action">
                                                <form method="dialog">
                                                    <button className="btn">Close</button>
                                                </form>
                                            </div>
                                        </div>
                                    </dialog>

                                    <h4 className='font-semibold text-[24px]'>{p.caption}</h4>
                                    <p className='mt-[10px] text-md'>{p.body}</p>
                                    <div className="mt-[20px] carousel w-full">
                                        {p.media.map((m, i) => <div id={`slide${i + 1}`} className="carousel-item relative w-full">
                                            {m.type == "video/mp4" ? <video controls={true} src={m.url}></video> : <img src={m.url} className="w-full" />}
                                        </div>)}
                                    </div>
                                    <div className='mt-[20px] flex gap-[20px] justify-between'>
                                        <div className='flex gap-[20px]'>
                                            <button>
                                                <div className='flex items-center gap-[5px]'>
                                                    <svg className='w-[24px] h-[24px]' viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path d="M8 10V20M8 10L4 9.99998V20L8 20M8 10L13.1956 3.93847C13.6886 3.3633 14.4642 3.11604 15.1992 3.29977L15.2467 3.31166C16.5885 3.64711 17.1929 5.21057 16.4258 6.36135L14 9.99998H18.5604C19.8225 9.99998 20.7691 11.1546 20.5216 12.3922L19.3216 18.3922C19.1346 19.3271 18.3138 20 17.3604 20L8 20" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path> </g></svg>
                                                    <span className=' text-md'>{p.likes}</span>
                                                </div>
                                            </button>
                                            <button>
                                                <div className='flex items-center gap-[5px]'>
                                                    <svg className='w-[24px] h-[24px]' viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path d="M8 14V4M8 14L4 14V4.00002L8 4M8 14L13.1956 20.0615C13.6886 20.6367 14.4642 20.884 15.1992 20.7002L15.2467 20.6883C16.5885 20.3529 17.1929 18.7894 16.4258 17.6387L14 14H18.5604C19.8225 14 20.7691 12.8454 20.5216 11.6078L19.3216 5.60779C19.1346 4.67294 18.3138 4.00002 17.3604 4.00002L8 4" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path> </g></svg>
                                                    <span className=' text-md'>{p.dislikes}</span>
                                                </div>
                                            </button>
                                        </div>
                                        <div className='flex gap-[5px]'>
                                            <button onClick={() => document.getElementById(`dialog-${p.id}`).showModal()} className='btn rounded-xl'>Edit</button>

                                            {filter !== "archive" ? <button onClick={() => handleArchivePost(p.id)} className='btn rounded-xl'>Archive</button> :
                                                <button onClick={() => handleUnArchivePost(p.id)} className='btn rounded-xl'>UnArchive</button>
                                            }
                                            <button onClick={() => handleDeletePost(p.id)} className='btn rounded-xl bg-red-400'>Delete</button>
                                        </div>
                                    </div>


                                </div>)}

                            </div>
                            <div className="join flex justify-center mt-[20px]">
                                {posts.current_page <= 1 ? null : <button onClick={() => handlePage(posts.current_page - 1)} className="join-item btn ">«</button>}
                                <button className="join-item btn">Page {posts.current_page} of {posts.total_page}</button>
                                {posts.current_page >= posts.total_page ? null : <button onClick={() => handlePage(posts.current_page + 1)} className="join-item btn ">»</button>}
                            </div>
                        </div>}
                </div>}
        </div>
    )
}


